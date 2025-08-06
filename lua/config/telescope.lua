local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

require('telescope').setup {
	-- You can put your default mappings / updates / etc. in here
	--  All the info you're looking for is in `:help telescope.setup()`
	--
	defaults = {
		mappings = {
			i = { ['<c-enter>'] = 'to_fuzzy_refine' },
			n = {
				['<C-d>'] = function(prompt_bufnr)
					local current_picker = action_state.get_current_picker(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection ~= nil then
						actions.close(prompt_bufnr)
						vim.api.nvim_buf_delete(selection.bufnr, { force = true })
						require('telescope.builtin').buffers()
						vim.defer_fn(function()
							vim.cmd('stopinsert')
						end, 20)
					end
				end,
			},
		},
	},
	-- pickers = {}
	extensions = {
		['ui-select'] = {
			require('telescope.themes').get_dropdown(),
		},
	},
}
