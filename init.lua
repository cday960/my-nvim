require('config.options')

require('config.lazy')
require('lazy').setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = true },
})

require('config.syntax_highlighting')
require('mappings')
vim.cmd.colorscheme "catppuccin-mocha"
require('config.telescope')
require('config.lualine')
require('config.tabby')
require('config.toggleterm')
require('config.mssql')
require('config.autotag')
-- require('config.treesitter')
require('config.lsp')
require('config.conform')
-- require('config.dbee')
