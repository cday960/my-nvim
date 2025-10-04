local map = vim.keymap.set

map('n', 'j', 'gj')
map('n', 'k', 'gk')

map('n', '<C-S-left>', ':vertical resize -5<cr>')
map('n', '<C-S-right>', ':vertical resize +5<cr>')
map('n', '<C-S-up>', ':resize +5<cr>')
map('n', '<C-S-down>', ':resize -5<cr>')

map('n', '<leader>1', '1gt')
map('n', '<leader>2', '2gt')
map('n', '<leader>3', '3gt')
map('n', '<leader>4', '4gt')
map('n', '<leader>5', '5gt')

map('n', '<leader>q', ':q<cr>')
map('n', '<C-s>', ':w<cr>', { noremap = true })

map('n', '<C-f>', ':Neotree toggle<cr>')
map('n', '<cr>', '/___<cr>', { silent = true })

map('n', '<leader>V', ':vsplit<cr>', { silent = true, desc = "Open vertical split" })

map('t', '<C-n>', "<C-\\><C-n>", { noremap = true })
-- map('t', '<C-ESC>', '<ESC>')

-----------------
--- TELESCOPE ---
-----------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>si', builtin.diagnostics, { desc = '[S]earch D[i]agnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>sd', builtin.lsp_definitions, { desc = '[S]earch for [D]efinition' })
vim.keymap.set('n', '<leader>sb', builtin.lsp_document_symbols, { desc = 'Search Sym[b]ols' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffers' })


-----------
--- SQL ---
-----------
function _G.SelectSQLBlock()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	-- Find the start of the block
	local start_line = row - 1
	while start_line > 0 and not lines[start_line]:match(";") do
		start_line = start_line - 1
	end
	if start_line > 0 then
		start_line = start_line + 1
	else
		start_line = 0
	end

	-- Find the end of the block
	local end_line = row - 1
	while end_line < #lines and not lines[end_line + 1]:match(";") do
		end_line = end_line + 1
	end

	-- Select the code
	vim.api.nvim_win_set_cursor(0, { start_line + 1, 0 })
	vim.cmd("normal! V")
	vim.api.nvim_win_set_cursor(0, { end_line + 1, 0 })

	vim.fn.setpos("'<", { 0, start_line + 1, 1, 0 })
	vim.fn.setpos("'>", { 0, end_line + 1, 1, 0 })

	vim.cmd(("%d,%dDB"):format(start_line + 1, end_line + 1))

	return start_line, end_line
end

-- map("n", "<leader>dr", SelectSQLBlock, { desc = "Run hovered SQL block with Dadbod" })
map("n", "<leader>dr", function()
	if _G.DBOutCloseAll then _G.DBOutCloseAll() end
	SelectSQLBlock()
end, { desc = "Run hovered SQL block with Dadbod" })

map("n", "<leader>dc", ":DBUIFindBuffer<cr>", { desc = "Start Dadbod UI on current buffer" })

map("n", "<leader>du", ":DBUIToggle<cr>", { desc = "Toggle Dadbod UI" })

map("n", "<leader>h", function()
	vim.diagnostic.open_float(nil, { focus = false })
end, { noremap = true, silent = true, desc = "Show LSP Diagnostics under cursor" })

-----------
--- HOP ---
-----------
map('n', 'f', ':HopCamelCaseMW<cr>', { silent = true, desc = "Hop Camel Case" })
map('n', 'F', ':HopAnywhereMW<cr>', { silent = true, desc = "Hop Anywhere" })
map('v', 'f', '<cmd>HopCamelCaseMW<cr>', { silent = true, desc = "Hop Camel Case" })
map('v', 'F', '<cmd>HopAnywhereMW<cr>', { silent = true, desc = "Hop Anywhere" })

----------------
--- Markview ---
----------------
map('n', '<leader>p', ':Markview toggle<cr>', { silent = true, desc = "Toggle Markview preview mode" })

---------------
--- Luasnip ---
---------------
local ls = require("luasnip")
map('i', '<Tab>', function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	else
		return "<Tab>"
	end
end, { expr = true, silent = true })

map('i', '<S-Tab>', function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	else
		return '<S-Tab>'
	end
end, { expr = true, silent = true })
