vim.opt.splitright = true

vim.cmd([[autocmd BufRead,BufNewFile *.slint set filetype=slint]])

-- kill sqlcmd on exit if sql buffers are open
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "sql" then
				vim.fn.system("pkill -f sqlcmd")
			end
		end
	end,
})

-------------------------
-- dbout -> visidata
-------------------------


local dbout_grp = vim.api.nvim_create_augroup("DBOutVisidata", { clear = true })

-- tracked state: { csv_path, term_buf }
-- local DBOUT = {}
_G.DBOUT = {}
_G.last_csv_path = nil

-- closes a single visidata instance
local function cleanup(winid)
	local s = DBOUT[winid]
	if not s then return end
	if s.term_buf and vim.api.nvim_buf_is_valid(s.term_buf) then
		pcall(vim.api.nvim_buf_delete, s.term_buf, { force = true })
	end
	if s.csv_path then pcall(os.remove, s.csv_path) end
	DBOUT[winid] = nil
end

-- closes all open dbout windows
_G.DBOutCloseAll = function()
	for winid, _ in pairs(DBOUT) do
		if vim.api.nvim_win_is_valid(winid) then
			pcall(vim.api.nvim_win_close, winid, true)
		end
		cleanup(winid)
	end
end

-- Detects border line after header row
local function is_border(s)
	return s:match("^[%-|]+$") ~= nil
end


-- splits a pipe-delimited line into trimmed cells.
local function split_cells(s)
	local cells = {}
	local pos = 1
	while pos <= #s do
		local sep = s:find("|", pos, true)
		if sep then
			cells[#cells + 1] = s:sub(pos, sep - 1):match("^%s*(.-)%s*$")
			pos = sep + 1
		else
			cells[#cells + 1] = s:sub(pos):match("^%s*(.-)%s*$")
			break
		end
	end
	-- handle trailing pipe
	if s:sub(-1) == "|" then
		cells[#cells + 1] = ""
	end
	if #cells == 0 then return nil end
	return cells
end

-- if a cell value contains a comma, quote, or newline wrap it in double quotes
local function csv_escape(s)
	s = tostring(s or "")
	if s:find('[,"\r\n]') then
		return '"' .. s:gsub('"', '""') .. '"'
	end
	return s
end


-- reads output lines from dbout, skips empties and border line, splits the
-- rest into cells. Combines cells into rows then appends them to a csv file.
local function dbout_to_csv(buf)
	local path = vim.fn.tempname() .. ".csv"
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	-- find the border line "-----|-----|-----|"
	local header_idx = nil
	for i, ln in ipairs(lines) do
		if is_border(ln) then
			header_idx = i - 1
			break
		end
	end

	if not header_idx or header_idx < 1 then return nil end

	local rows = {}

	-- header
	local header_cells = split_cells(lines[header_idx])
	if not header_cells then return nil end
	rows[#rows + 1] = header_cells

	-- data rows
	for i = header_idx + 2, #lines do
		local ln = lines[i]
		if #ln > 0 and not is_border(ln) then
			local cells = split_cells(ln)
			if cells and #cells == #header_cells then
				rows[#rows + 1] = cells
			end
		end
	end

	if #rows <= 1 then return nil end

	-- local rows = {}
	-- for _, ln in ipairs(lines) do
	-- 	if #ln > 0 and not is_border(ln) then
	-- 		local cells = split_cells(ln)
	-- 		if cells then rows[#rows + 1] = cells end
	-- 	end
	-- end
	--
	-- if #rows == 0 then return nil end

	local fd = io.open(path, "w")
	if not fd then return nil end

	-- loop through cells, do csv_escape on cell to prevent double quotes
	-- and new line symbols from being thrown out.
	-- write formatted csv line to file.
	for _, cells in ipairs(rows) do
		for i = 1, #cells do cells[i] = csv_escape(cells[i]) end
		fd:write(table.concat(cells, ","), "\n")
	end
	fd:close()
	return path
end


local function convert_dbout_to_vd()
	local dbout_buf

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "dbout" then
			dbout_buf = buf
			break
		end
	end

	if not dbout_buf then
		vim.notify("No dbout buffer found", vim.log.levels.WARN)
		return
	end

	-- find the window
	local win
	for _, w in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(w) == dbout_buf then
			win = w
			break
		end
	end
	if not win then
		vim.notify("No window showing dbout", vim.log.levels.WARN)
		return
	end

	-- move right
	vim.api.nvim_set_current_win(win)
	vim.cmd("wincmd L")
	win = vim.api.nvim_get_current_win()

	local csv_path = dbout_to_csv(dbout_buf)
	if not csv_path then
		vim.notify("dbout: no rows to display", vim.log.levels.WARN)
		return
	end

	if vim.fn.executable("vd") ~= 1 then
		vim.notify("vd not found in PATH", vim.log.levels.ERROR)
		return
	end

	local term_buf = vim.api.nvim_create_buf(false, true)
	vim.bo[term_buf].filetype = ""
	pcall(function() vim.treesitter.stop(term_buf) end)

	vim.api.nvim_win_set_buf(win, term_buf)
	vim.fn.termopen("vd " .. vim.fn.shellescape(csv_path), {
		on_exit = function()
			vim.schedule(function() cleanup(win) end)
		end,
	})

	pcall(function() vim.treesitter.stop(term_buf) end)
	vim.cmd("startinsert")

	if vim.api.nvim_buf_is_valid(dbout_buf) then
		pcall(vim.api.nvim_buf_delete, dbout_buf, { force = true })
	end

	DBOUT[win] = { csv_path = csv_path, term_buf = term_buf }
end

vim.api.nvim_create_user_command("DBOut", convert_dbout_to_vd, {})

-- Calls cleanup if window is closed using :q
vim.api.nvim_create_autocmd("WinClosed", {
	group = dbout_grp,
	callback = function(ev)
		local closed = tonumber(ev.match)
		if closed then cleanup(closed) end
	end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter", "BufReadPost", "BufNewFile" }, {
	group = dbout_grp,
	callback = function(args)
		if vim.bo[args.buf].filetype ~= "dbout" then return end
		if not vim.wo.previewwindow then return end

		local ok, done = pcall(vim.api.nvim_buf_get_var, args.buf, "vd_handled")
		if ok and done then return end
		pcall(vim.api.nvim_buf_set_var, args.buf, "vd_handled", true)

		vim.defer_fn(convert_dbout_to_vd, 500)
	end,
})


vim.api.nvim_create_user_command("DBOutSave", function(opts)
	local csv_path
	for _, s in pairs(DBOUT) do
		if s.csv_path then
			csv_path = s.csv_path; break
		end
	end
	if not csv_path then
		vim.notify("No dbout CSV to save", vim.log.levels.WARN)
		return
	end

	local dest = opts.args
	if dest == "" then
		dest = vim.fn.input("Save CSV to: ", vim.fn.getcwd() .. "/export.csv")
		if dest == "" then return end
	end

	vim.fn.mkdir(vim.fn.fnamemodify(dest, ":h"), "p")
	local ok, err = pcall(vim.uv.fs_copyfile, csv_path, dest)
	if ok then
		vim.notify("Saved: " .. dest, vim.log.levels.INFO)
	else
		vim.notify("Save failed: " .. tostring(err), vim.log.levels.ERROR)
	end
end, { nargs = "?", complete = "file" })

------------------------------------------
--- HEATMAP ---
------------------------------------------





vim.api.nvim_create_user_command("DBHeatmap", function(opts)
	-- parse args respecting quoted strings
	local args = {}
	local remaining = opts.args
	while #remaining > 0 do
		remaining = remaining:match("^%s*(.-)%s*$")
		if remaining:sub(1, 1) == '"' then
			local closing = remaining:find('"', 2)
			if closing then
				args[#args + 1] = remaining:sub(2, closing - 1)
				remaining = remaining:sub(closing + 1)
			else
				break
			end
		else
			local word, rest = remaining:match("^(%S+)%s*(.*)")
			if word then
				args[#args + 1] = word
				remaining = rest
			else
				break
			end
		end
	end

	if #args < 3 then
		vim.notify('Usage: :DBHeatmap "row_col" "col_col" filename [title]', vim.log.levels.WARN)
		return
	end


	local csv_path
	for _, s in pairs(DBOUT) do
		if s.csv_path then
			csv_path = s.csv_path; break
		end
	end
	if not csv_path then
		-- vim.notify("No dbout CSV found", vim.log.levels.WARN)
		vim.notify("args count: " .. tostring(#args))
		return
	end


	local row_col = args[1]
	local col_col = args[2]
	local filename = args[3]

	-- add .png if not already there
	if not filename:match("%.png$") then
		filename = filename .. ".png"
	end

	local png_path = vim.fn.getcwd() .. "/" .. filename
	local title = args[4] or nil

	local cmd = string.format(
		"python3 ~/.config/nvim/scripts/dbout_heatmap.py %s %s %s %s %s",
		vim.fn.shellescape(csv_path),
		vim.fn.shellescape(row_col),
		vim.fn.shellescape(col_col),
		vim.fn.shellescape(png_path),
		title and vim.fn.shellescape(title) or "''"
	)

	local result = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		vim.notify("Heatmap failed: " .. result, vim.log.levels.ERROR)
		return
	end

	vim.notify("Heatmap saved: " .. png_path, vim.log.levels.INFO)
end, { nargs = "*" })
