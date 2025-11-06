require('config.options')
require('config.dadbod')

require('config.lazy')
require('lazy').setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = true },
})

require('config.treesitter')
require('config.syntax_highlighting')

require('config.auto')

require('config.telescope')
require('config.lualine')
require('config.tabby')
require('config.toggleterm')
require('config.mssql')
require('config.lsp')
require('config.conform')
require('config.autotag')

-- require('config.auto')

require('config.luasnip')

require('config.theme')
-- Mappings last
require('mappings')
