vim.g.mapleader = ';'
vim.g.maplocalleader = ';'

vim.o.number = true
vim.o.relativenumber = true

vim.g.have_nerd_font = true
vim.o.termguicolors = true

vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

vim.o.breakindent = true
vim.o.autoindent = true

vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250

vim.o.timeoutlen = 500

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.inccommand = 'split'

vim.o.cursorline = true

vim.o.scrolloff = 10


require('config.lazy')
require('lazy').setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = true },
})

require('mappings')
vim.cmd.colorscheme "catppuccin-mocha"
require('config.telescope')
require('config.lualine')
require('config.tabby')
require('config.toggleterm')
