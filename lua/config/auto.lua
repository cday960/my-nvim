vim.opt.splitright = true

-- vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
-- 	pattern = { "dbout" },
-- 	callback = function()
-- 		if vim.wo.previewwindow then
-- 			vim.cmd("wincmd L")
-- 			-- vim.cmd("vertical resize 70")
-- 		end
-- 	end,
-- })


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
