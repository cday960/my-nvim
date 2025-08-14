local colors = {
	bg = "#1a1b26",
	fg = "#c0caf5",
	blue = "#7aa2f7",
	lightblue = "#89b4fa",
	green = "#9ece6a",
	purple = "#bb9af7",
	cyan = "#7dcfff",
	yellow = "#e0af68",
	orange = "#ff9e64",
	red = "#f7768e",
	text = "#cdd6f4",
}

require('nvim-treesitter.configs').setup({
	highlight = {
		enable = true,
		vim.api.nvim_set_hl(0, "@keyword.sql", { fg = "#36c438", bold = false }),
		-- vim.api.nvim_set_hl(0, "@tag.html", { fg = colors.lightblue }),  -- <div>, <a>, etc.
		vim.api.nvim_set_hl(0, "htmlTagName", { fg = colors.lightblue }), -- <div>, <a>, etc.
		-- vim.api.nvim_set_hl(0, "@tag.delimiter.html", { fg = colors.fg }), -- <, >, </, />
		vim.api.nvim_set_hl(0, "htmlTag", { fg = colors.fg }),          -- <, >, </, />
		vim.api.nvim_set_hl(0, "djangoTagBlock", { fg = colors.fg }),   -- <, >, </, />
		-- vim.api.nvim_set_hl(0, "@attribute.html", { fg = colors.yellow }), -- href, class, id, etc.
		vim.api.nvim_set_hl(0, "htmlArg", { fg = colors.yellow }),      -- href, class, id, etc.
		-- vim.api.nvim_set_hl(0, "@string.html", { fg = colors.green }),  -- "value" of attributes
		vim.api.nvim_set_hl(0, "htmlString", { fg = colors.green }),    -- "value" of attributes
		-- vim.api.nvim_set_hl(0, "@comment.html", { fg = colors.blue, italic = true }),
		vim.api.nvim_set_hl(0, "htmlComment", { fg = colors.blue, italic = true }),
		-- vim.api.nvim_set_hl(0, "@function.htmldjango", { fg = colors.red }),
		vim.api.nvim_set_hl(0, "djangoStatement", { fg = colors.red }),
		vim.api.nvim_set_hl(0, "@keyword.repeat.htmldjango", { fg = colors.red }),

		vim.api.nvim_set_hl(0, "@markup.heading.1.html", { fg = colors.text }),
		vim.api.nvim_set_hl(0, "@markup.heading.html", { fg = colors.text }),
		vim.api.nvim_set_hl(0, "@variable.htmldjango", { fg = colors.text }),
	},
	additional_vim_regex_highlighting = { "htmldjango", "html" },
	injection = {
		enabled = true,
	}
})
