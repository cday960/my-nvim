require('neo-tree').setup({
	filesystem = {
		filtered_items = {
			visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
			hide_dotfiles = false,
			hide_gitignored = false,
			hide_by_name = {
				".git",
				".venv",
				".python-version",
				"__pycache__"
			}
		},
		follow_current_file = {
			enabled = true,
		},
	},
	-- buffers = {
	-- 	follow_current_file = {
	-- 		enabled = true,
	-- 	},
	-- },
})
