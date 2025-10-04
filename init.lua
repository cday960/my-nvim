require('config.options')

require('config.lazy')
require('lazy').setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = true },
})

require('config.treesitter')
require('config.syntax_highlighting')
vim.cmd.colorscheme "catppuccin-mocha"
require('config.telescope')
require('config.lualine')
require('config.tabby')
require('config.toggleterm')
require('config.mssql')
require('config.lsp')
require('config.conform')
require('config.autotag')
require('config.dadbod')
require('config.auto')
require('config.luasnip')

-- Mappings last
require('mappings')
