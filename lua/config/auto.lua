vim.opt.splitright = true

local grp = vim.api.nvim_create_augroup("DadbodVerticalOnce", { clear = true })

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
	group = grp,
	callback = function()
		-- Only effect dadbod result buffers
		if vim.bo.filetype ~= "dbout" then return end
		-- only effect preview windows
		if not vim.wo.previewwindow then return end

		-- skip if old window
		local ok, pinned = pcall(vim.api.nvim_win_get_var, 0, "dbout_pinned")
		if ok and pinned then return end

		-- First time opening preview window
		vim.cmd("wincmd L")

		-- set pin
		pcall(vim.api.nvim_win_set_var, 0, "dbout_pinned", true)
	end,
})

local function format_dbout(bufnr)
	if vim.b.dbout_formatted == 1 then return end
	if vim.fn.executable("column") ~= 1 then return end

	vim.schedule(function()
		if not vim.api.nvim_buf_is_valid(bufnr) then return end
		local ro, mod = vim.bo[bufnr].readonly, vim.bo[bufnr].modifiable
		vim.bo[bufnr].readonly = false
		vim.bo[bufnr].modifiable = true

		local view = vim.fn.winsaveview()
		vim.api.nvim_buf_call(bufnr, function()
			-- vim.cmd([[silent keepjumps keepalt %!column -t -s'|']])  -- OLD
			vim.cmd([[silent keepjumps keepalt %!column -t -s'|' -o $'\t']])
			vim.cmd("silent noautocmd setlocal nomodified")
		end)
		vim.fn.winrestview(view)

		vim.bo[bufnr].modifiable = mod
		vim.bo[bufnr].readonly = ro
		vim.b.dbout_formatted = 1
	end)
end

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
	pattern = "dbout",
	callback = function(args) format_dbout(args.buf) end,
})

--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------

-- ── Sticky header that respects gutter (numbers/signs) and horizontal scroll ──
local sticky_grp = vim.api.nvim_create_augroup("DBOutStickyHeader", { clear = true })

vim.api.nvim_set_hl(0, "DBOutStickyHeader", { bg = "#3b5c54", fg = "#c0caf5" })
--
-- Add near the top (helpers)
local function expand_tabs(s, ts)
	local out, col = {}, 0
	for i = 1, #s do
		local ch = s:sub(i, i)
		if ch == "\t" then
			local spaces = ts - (col % ts)
			out[#out + 1] = string.rep(" ", spaces)
			col = col + spaces
		else
			out[#out + 1] = ch
			col = col + 1
		end
	end
	return table.concat(out)
end

-- per-window state: [winid] = { sticky_win, sticky_buf, src_buf, last_leftcol, last_width, last_header, last_textoff }
local STICKY = {}

local function close_sticky(winid)
	local s = STICKY[winid]
	if not s then return end
	if s.sticky_win and vim.api.nvim_win_is_valid(s.sticky_win) then pcall(vim.api.nvim_win_close, s.sticky_win, true) end
	if s.sticky_buf and vim.api.nvim_buf_is_valid(s.sticky_buf) then
		pcall(vim.api.nvim_buf_delete, s.sticky_buf,
			{ force = true })
	end
	STICKY[winid] = nil
end

local function first_nonempty(buf)
	local n = vim.api.nvim_buf_line_count(buf)
	if n == 0 then return " " end
	for _, ln in ipairs(vim.api.nvim_buf_get_lines(buf, 0, math.min(5, n), false)) do
		if ln:match("%S") then return ln end
	end
	return " "
end

-- slice header to visible columns (ASCII-safe)
local function slice_cols(s, leftcol, width)
	local from = leftcol + 1
	local to   = leftcol + width
	if from > #s then return string.rep(" ", width) end
	local piece = s:sub(from, to)
	local pad = width - #piece
	if pad > 0 then piece = piece .. string.rep(" ", pad) end
	return piece
end

local function textoff_for(winid)
	local info = vim.fn.getwininfo(winid)
	if type(info) == "table" and info[1] then
		return tonumber(info[1].textoff) or 0
	end
	return 0
end

local function ensure_header(winid, buf)
	local s       = STICKY[winid]
	local win_w   = vim.api.nvim_win_get_width(winid)
	local off     = textoff_for(winid)      -- gutter: numbers/signs/folds width
	local inner_w = math.max(1, win_w - off) -- content area width

	if not (s and vim.api.nvim_win_is_valid(s.sticky_win) and vim.api.nvim_buf_is_valid(s.sticky_buf)) then
		-- create sticky window/buffer
		close_sticky(winid)
		local sbuf = vim.api.nvim_create_buf(false, true)
		vim.bo[sbuf].buftype, vim.bo[sbuf].bufhidden, vim.bo[sbuf].swapfile = "nofile", "wipe", false
		vim.bo[sbuf].modifiable = true

		local swin = vim.api.nvim_open_win(sbuf, false, {
			relative = "win",
			win = winid,
			row = 0,
			col = off,    -- <<< shift right by gutter
			width = inner_w, -- <<< only cover text area
			height = 1,
			focusable = false,
			style = "minimal",
			noautocmd = true,
			zindex = 60,
		})
		vim.wo[swin].wrap, vim.wo[swin].signcolumn, vim.wo[swin].foldcolumn, vim.wo[swin].cursorline = false, "no", "0",
				false
		-- vim.wo[swin].winhl = "Normal:NormalFloat"
		vim.wo[swin].winhl = "Normal:DBOutStickyHeader"

		STICKY[winid] = {
			sticky_win = swin,
			sticky_buf = sbuf,
			src_buf = buf,
			last_leftcol = -1,
			last_width = -1,
			last_header = "",
			last_textoff = -1,
		}
		s = STICKY[winid]
	end

	-- read that window's view (for leftcol) safely
	local view = vim.api.nvim_win_call(winid, function() return vim.fn.winsaveview() end)
	local left = view.leftcol or 0
	local header = first_nonempty(buf)

	local ts = tonumber(vim.bo[buf].tabstop) or 8
	header = expand_tabs(header, ts)

	-- only rerender if something changed
	if left == s.last_leftcol and inner_w == s.last_width and header == s.last_header and off == s.last_textoff then
		return
	end
	s.last_leftcol, s.last_width, s.last_header, s.last_textoff = left, inner_w, header, off

	-- update text (sliced to visible range)
	local text = slice_cols(header, left, inner_w)
	local underline = text:gsub("%S", "-")

	if not (vim.api.nvim_buf_is_valid(s.sticky_buf) and vim.api.nvim_win_is_valid(s.sticky_win)) then
		close_sticky(winid)
		return ensure_header(winid, buf)
	end

	vim.bo[s.sticky_buf].modifiable = true
	local ok = pcall(vim.api.nvim_buf_set_lines, s.sticky_buf, 0, -1, false, { text })
	vim.bo[s.sticky_buf].modifiable = false

	if not ok then
		close_sticky(winid)
		return ensure_header(winid, buf)
	end


	-- keep float aligned/reshaped if width or textoff changed
	local cfg = vim.api.nvim_win_get_config(s.sticky_win)
	local need = (cfg.width ~= inner_w) or (cfg.col ~= off)
	if need then
		cfg.width = inner_w
		cfg.col   = off
		pcall(vim.api.nvim_win_set_config, s.sticky_win, cfg)
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = sticky_grp,
	pattern = "dbout",
	callback = function(args)
		local win, buf = vim.api.nvim_get_current_win(), args.buf
		ensure_header(win, buf)

		-- update on content changes (rerun query)
		vim.api.nvim_buf_attach(buf, false, {
			on_lines = function()
				vim.schedule(function()
					if vim.api.nvim_win_is_valid(win) then ensure_header(win, buf) end
				end)
				return false
			end,
		})

		-- follow horizontal/vertical scroll and resizes (incl. gutter width changes)
		vim.api.nvim_create_autocmd({ "WinScrolled", "CursorMoved", "CursorMovedI", "WinResized", "OptionSet" }, {
			group = sticky_grp,
			callback = function(ev)
				-- OptionSet captures number/sign/fold changes; filter to current win
				if ev.event == "OptionSet" and not vim.api.nvim_win_is_valid(win) then return end
				if vim.api.nvim_win_is_valid(win) then ensure_header(win, buf) end
			end,
			desc = "Sync dbout sticky header with scroll/resize/gutter changes",
		})

		-- cleanup
		vim.api.nvim_create_autocmd("WinClosed", {
			group = sticky_grp,
			callback = function(ev)
				local closed = tonumber(ev.match); if closed then close_sticky(closed) end
			end,
		})
	end,
})



------------------------------------------------------------------

-- ── dbout export helpers (pure Lua) ──
local function is_border_line(s)
	return s:match("^%s*[%+%-]+[%+%- ]*$") ~= nil
			or s:match("^%s*%|?%s*[-%s%|]+$") ~= nil
end

local function split_pipe_row(s)
	s = s:gsub("^%s*|", ""):gsub("|%s*$", "")
	local cells = {}
	for cell in s:gmatch("([^|]+)") do
		cells[#cells + 1] = (cell:gsub("^%s+", ""):gsub("%s+$", ""))
	end
	return cells
end

local function split_tab_row(s)
	local cells = {}
	for cell in s:gmatch("([^\t]+)") do
		cells[#cells + 1] = cell
	end
	return cells
end

local function line_to_cells(s)
	if s:find("|", 1, true) then
		return split_pipe_row(s)
	elseif s:find("\t", 1, true) then
		return split_tab_row(s)
	else
		return nil
	end
end

local function csv_escape(s)
	if s == nil then return "" end
	s = tostring(s)
	if s:find('[,"\r\n]') then
		s = '"' .. s:gsub('"', '""') .. '"'
	end
	return s
end

local function buffer_rows(buf)
	local rows = {}
	for _, ln in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
		if #ln > 0 and not is_border_line(ln) then
			local cells = line_to_cells(ln)
			if cells and #cells > 0 then rows[#rows + 1] = cells end
		end
	end
	return rows
end

local function write_csv(buf, path, sep, is_csv)
	local rows = buffer_rows(buf)
	if #rows == 0 then
		vim.notify("dbout export: no table rows detected", vim.log.levels.WARN); return
	end
	local ok, err = pcall(function()
		vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
		local fd = assert(io.open(path, "w"))
		for _, cells in ipairs(rows) do
			if is_csv then
				for i = 1, #cells do cells[i] = csv_escape(cells[i]) end
			end
			fd:write(table.concat(cells, sep), "\n")
		end
		fd:close()
	end)
	if ok then
		vim.notify(("Wrote %s: %s"):format(is_csv and "CSV" or "TSV", path), vim.log.levels.INFO)
	else
		vim.notify("Export failed: " .. tostring(err), vim.log.levels.ERROR)
	end
end

vim.api.nvim_create_user_command("DBOutWriteCSV", function(opts)
	local path = opts.args
	if path == "" then
		path = vim.fn.input("Write CSV to: ", (vim.fn.getcwd() .. "/export.csv"))
		if path == "" then return end
	end
	write_csv(vim.api.nvim_get_current_buf(), path, ",", true)
end, { nargs = "?" })

vim.api.nvim_create_user_command("DBOutWriteTSV", function(opts)
	local path = opts.args
	if path == "" then
		path = vim.fn.input("Write TSV to: ", (vim.fn.getcwd() .. "/export.tsv"))
		if path == "" then return end
	end
	write_csv(vim.api.nvim_get_current_buf(), path, "\t", false)
end, { nargs = "?" })
