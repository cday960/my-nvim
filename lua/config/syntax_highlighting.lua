require('nvim-treesitter.configs').setup({
	highlight = {
		enable = true,
		-- vim.api.nvim_set_hl(0, "@keyword.sql", { fg = "#b0ffc0", bold = false }),
		-- vim.api.nvim_set_hl(0, "@keyword.sql", { fg = "#28c62a", bold = false }),
		vim.api.nvim_set_hl(0, "@keyword.sql", { fg = "#36c438", bold = false }),

		-- vim.api.nvim_set_hl(0, "@keyword.operator.sql", { fg = "#4287f5", bold = false }),
		-- vim.api.nvim_set_hl(0, "@type.sql", { fg = "#b2b2b2", bold = false }),
	}
})

-- vim.api.nvim_set_hl(0, "@keyword.sql", { fg = "#b0ffc0", bold = false })
-- vim.api.nvim_set_hl(0, "@keyword.operator.sql", { fg = "#4287f5", bold = false })
-- vim.api.nvim_set_hl(0, "@type.sql", { fg = "#b0ffc0", bold = true })
-- vim.api.nvim_set_hl(0, "@type.sql", { fg = "#b2b2b2", bold = false })
