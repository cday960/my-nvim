local lspconfig = require('lspconfig')
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true


vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup('lsp', { clear = true }),
	callback = function(args)
		vim.api.nvim_create_autocmd('BufWritePre', {
			buffer = args.buf,
			callback = function()
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
			diagnostics = {
				globals = { 'vim' }
			}
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
-- vim.lsp.enable("sqlls")
-- vim.lsp.enable("sqlls", {
-- 	capabilities = capabilities,
-- })

local function set_python_path(path)
	local clients = vim.lsp.get_clients {
		bufnr = vim.api.nvim_get_current_buf(),
		name = 'pyright',
	}
	for _, client in ipairs(clients) do
		if client.settings then
			client.settings.python = vim.tbl_deep_extend('force', client.settings.python, { pythonPath = path })
		else
			client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
		end
		client.notify('workspace/didChangeConfiguration', { settings = nil })
	end
end

vim.lsp.config.pyright = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git"
	},
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true
			}
		}
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightOrganizeImports', function()
			client:exec_cmd({
				command = 'pyright.organizeimports',
				arguments = { vim.uri_from_bufnr(bufnr) },
			})
		end, {
			desc = 'Organize Imports',
		})
		vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightSetPythonPath', set_python_path, {
			desc = 'Reconfigure pyright with the provided python path',
			nargs = 1,
			complete = 'file',
		})
	end,
}
vim.lsp.enable('pyright')


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config.html = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "templ" },
	root_markers = { "package.json", ".git" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true
		},
		provideFormatter = true
	},
	capabilities = capabilities,
}
vim.lsp.enable('html')

vim.lsp.config.cssls = {
	capabilities = capabilities,
}
vim.lsp.enable('cssls')



------------------------------------
-- CMP Setup
------------------------------------

local luasnip = require('luasnip')
local cmp = require('cmp')

vim.lsp.handlers["textDocument/completion"] = function(err, result, ctx, config)
	print(vim.inspect(result))
	return result
end


cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'buffer' },
		{ name = 'luasnip' },
	},
	mapping = cmp.mapping.preset.insert({
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-j>'] = cmp.mapping.select_next_item(),
		['<C-k>'] = cmp.mapping.select_prev_item(),
		['<Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end,
		['<S-Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end,
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
	}),
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered()
	},
	completion = {
		keyword_length = 1,
	},
	matching = {
		disallow_fuzzy_matching = false,
		disallow_partial_matching = false,
		disallow_prefix_unmatching = false,
		pattern = [[^.*]]
	},
	formatting = {
		fields = { "abbr", "menu", 'kind' },
		format = function(entry, vim_item)
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
			})[entry.source.name]
			return vim_item
		end,
	}
}
