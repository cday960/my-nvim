require('conform').setup({
	formatters_by_ft = {
		-- python = { "black" },
		python = { "ruff_format", "ruff_fix" },
		html = { "djlint" },
		django = { "djlint" },
		htmldjango = { "djlint" },
		sql = { "sqlfluff" },
	},
	formatters = {
		sqlfluff = {
			args = { "format", "--dialect=tsql", "-" },
		},
	},
	format_on_save = function(bufnr)
		-- On SQL only use sqlfluff
		if vim.bo[bufnr].filetype == "sql" then
			-- return { timeout_ms = 2000, lsp_fallback = false }
			return false
		end
		return { timeout_ms = 500, lsp_fallback = true }
	end,
	format_after_save = function(bufnr)
		if vim.bo[bufnr].filetype == "sql" then
			return { lsp_fallback = false }
		end
		return false
	end,
	-- format_on_save = {
	-- 	timeout_ms = 500,
	-- 	lsp_fallback = true,
	-- }
})
