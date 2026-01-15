require('conform').setup({
	formatters_by_ft = {
		-- python = { "black" },
		python = { "ruff_format", "ruff_fix" },
		html = { "djlint" },
		django = { "djlint" },
		htmldjango = { "djlint" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	}
})
