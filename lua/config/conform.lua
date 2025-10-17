require('conform').setup({
	formatters_by_ft = {
		-- python = { "black" },
		python = { "ruff_format", "ruff_fix" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	}
})
