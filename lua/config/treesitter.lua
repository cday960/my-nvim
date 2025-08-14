require('nvim-treesitter').setup({
	injection = {
		enabled = true,
	},
})

require('nvim-treesitter.configs').setup {
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "htmldjango", "html" },
	},
}

-- safely import tree-sitter
local treesitter_imported_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not treesitter_imported_ok then return end


local register = vim.treesitter.language.register
register('html', 'htmldjango') -- enable html parser in htmldjango file
