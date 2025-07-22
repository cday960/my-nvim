local lspconfig = require('lspconfig')
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Format on save
-- vim.api.nvim_create_autocmd('BufWritePre', {
-- 	callback = function()
-- 		vim.lsp.buf.format {
-- 			async = false,
-- 		}
-- 	end,
-- })


vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup('lsp', { clear = true }),
	callback = function(args)
		-- local format_is_enabled = true
		-- local client_id = args.data.client_id
		-- local client = vim.lsp.get_client_by_id(client_id)
		-- local bufnr = args.buf
		-- if not client.server_capabilities.documentFormattingProvider then
		-- 	return
		-- end
		--
		vim.api.nvim_create_autocmd('BufWritePre', {
			buffer = args.buf,
			callback = function()
				-- if not format_is_enabled then
				-- 	return
				-- end
				vim.lsp.buf.format {
					async = false,
					id = args.data.client_id,
				}
			end,
		})
	end,
})

vim.lsp.config.lua_ls = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".git", vim.uv.cwd() },
	capabilities = capabilities,
	settings = {
		Lua = {
			telemetry = {
				enable = false,
			},
		},
	},
}
vim.lsp.enable("lua_ls")

vim.lsp.config.sqlls = {
	cmd = { "sql-language-server", "up", "--method", "stdio" },
	filetypes = { "sql", "mysql" },
	root_markers = { ".sqllsrc.json", vim.uv.cwd() },
	capabilities = capabilities,
	settings = {}
}
vim.lsp.enable("sqlls")
