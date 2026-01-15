local lspconfig = require('lspconfig')
local util = require('lspconfig.util')
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.snippetSupport = true


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
		pyright = {
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				ignore = { '*' },
			}
		}
	},
	on_attach = function(client, bufnr)
		-- vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightOrganizeImports', function()
		-- 	client:exec_cmd({
		-- 		command = 'pyright.organizeimports',
		-- 		arguments = { vim.uri_from_bufnr(bufnr) },
		-- 	})
		-- end, {
		-- 	desc = 'Organize Imports',
		-- })

		vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightSetPythonPath', set_python_path, {
			desc = 'Reconfigure pyright with the provided python path',
			nargs = 1,
			complete = 'file',
		})
	end,
}
vim.lsp.enable('pyright')


-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config.html = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "templ", "htmldjango" },
	root_markers = { "package.json", ".git" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true
		},
		provideFormatter = false
	},
	capabilities = capabilities,
}
vim.lsp.enable('html')


vim.lsp.config.cssls = {
	capabilities = capabilities,
}
vim.lsp.enable('cssls')

vim.lsp.config.ts_ls = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	init_options = {
		hostInfo = "neovim"
	},
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" }
}
vim.lsp.enable('ts_ls')


vim.lsp.config.oxlint = {
	cmd = { "oxc_language_server" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local root_markers = util.insert_package_json({ '.oxlint.json' }, 'oxlint', fname)
		on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true })[1]))
	end,
}
-- vim.lsp.enable('oxlint')


vim.lsp.config.eslint = {
	settings = {
		format = {
			enable = true,
		}
	},
	-- on_attach = function(client, bufnr)
	-- 	if not eslint_on_attach then return end
	--
	-- 	eslint_on_attach(client, bufnr)
	-- 	vim.api.nvim_create_autocmd("BufWritePre", {
	-- 		buffer = bufnr,
	-- 		command = "LspEslintFixAll",
	-- 	})
	-- end,
}
local base_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config("eslint", {
	on_attach = function(client, bufnr)
		if not base_on_attach then return end

		base_on_attach(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "LspEslintFixAll",
		})
	end,
})
vim.lsp.enable('eslint')


vim.lsp.config("yamlls", {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
	capabilities = capabilities,
	root_markers = { ".git" },
	settings = {
		-- yaml = {
		-- 	schemas = {
		-- 		[""] = "",
		-- 	},
		-- },
		redhat = {
			telemetry = {
				enabled = false
			}
		}
	}
})

vim.lsp.enable('yamlls')

vim.lsp.config('slint_lsp', {
	cmd = { "slint-lsp" },
	filetypes = { "slint" },
	root_markers = { ".git" },
})

vim.lsp.enable('slint_lsp')

-- Now works from rustace plugin
-- vim.lsp.config('rust_analyzer', {
-- 	settings = {
-- 		['rust-analyzer'] = {
-- 			-- diagnostics = {
-- 			-- 	enable = true,
-- 			-- }
-- 			capabilities = {
-- 				serverStatusNotification = true,
-- 			},
-- 			cmd = { "rust-analyzer" },
-- 			filetypes = { "rust" },
-- 		}
-- 	}
-- })
--
-- vim.lsp.enable('rust_analyzer')

-- vim.lsp.config('ruff', {
-- 	init_options = {
-- 		settings = {
-- 			-- lsp settings here
-- 		}
-- 	}
-- })
vim.lsp.enable('ruff')


------------------------------------
-- CMP Setup
------------------------------------

local luasnip = require('luasnip')
local cmp = require('cmp')

vim.lsp.handlers["textDocument/completion"] = function(err, result, ctx, config)
	print(vim.inspect(result))
	return result
end

vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
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
		-- { name = 'vim-dadbod-completion' },
	},
	mapping = cmp.mapping.preset.insert({
		-- ['<C-u>'] = cmp.mapping.scroll_docs(-4),
		-- ['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-j>'] = cmp.mapping.select_next_item(),
		['<C-k>'] = cmp.mapping.select_prev_item(),
		['<Tab>'] = function(fallback)
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		-- ['<Tab>'] = function(fallback)
		-- 	if cmp.visible() then
		-- 		cmp.select_next_item()
		-- 	else
		-- 		fallback()
		-- 	end
		-- end,
		-- ['<S-Tab>'] = function(fallback)
		-- 	if cmp.visible() then
		-- 		cmp.select_prev_item()
		-- 	else
		-- 		fallback()
		-- 	end
		-- end,
		-- ['<C-Space>'] = cmp.mapping.complete(),
		--
		-- ['<CR>'] = cmp.mapping.confirm {
		-- 	behavior = cmp.ConfirmBehavior.Replace,
		-- 	select = true,
		-- },
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

cmp.setup.filetype({ "sql" }, {
	sources = {
		{ name = "vim-dadbod-completion" },
		{ name = "buffer" },
	}
})
