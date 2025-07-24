require("mssql").setup({
	keymap_prefix = "<leader>m",
	open_results_in = "vsplit",
	max_column_width = 50,
	results_buffer_filetype = "",
	lsp_settings = {
		format = {
			keywordCasing = "Lowercase",
			datatypeCasing = "Lowercase",
			placeSelectStatementReferencesOnNewLine = true,
		},
		intelliSense = {
			lowerCaseSuggestions = true,
		}
	}
})
