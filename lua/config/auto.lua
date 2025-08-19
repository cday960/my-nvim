vim.opt.splitright = true

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
	pattern = { "dbout" },
	callback = function()
		if vim.wo.previewwindow then
			vim.cmd("wincmd L")
			vim.cmd("vertical resize 70")
		end
	end,
})
