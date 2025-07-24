local capabilities = require("cmp_nvim_lsp").default_capabilities()
local luasnip = require('luasnip')
local cmp = require('cmp')
local lspconfig = require('lspconfig')

local servers = {
	"lua_ls",
	"sqlls",
}


vim.lsp.handlers["textDocument/completion"] = function(err, result, ctx, config)
	print(vim.inspect(result and result.items or result)) -- view completion payload
	vim.lsp.handlers["textDocument/completion_default"](err, result, ctx, config)
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
	},
	mapping = cmp.mapping.preset.insert({
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-j>'] = cmp.mapping.select_next_item(),
		['<C-k>'] = cmp.mapping.select_prev_item(),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
	}),
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered()
	}
}





-- for _, lsp in ipairs(servers) do
-- 	lspconfig[lsp].setup {
-- 		-- on_attach = my_custom_on_attach,
-- 		capabilities = capabilities,
-- 	}
-- end
