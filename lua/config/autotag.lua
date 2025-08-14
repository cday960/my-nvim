-- require('nvim-ts-autotag').setup({
-- 	opts = {
-- 		enable_close = true,
-- 		enable_rename = true,
-- 		enable_close_on_slash = true,
-- 	},
-- 	aliases = {
-- 		-- ["htmldjango"] = "html",
-- 		-- ["html"] = "htmldjango",
-- 	}
-- })


local import_tag, autotag = pcall(require, "nvim-ts-autotag")
if not import_tag then return end
autotag.setup({
	autotag = {
		enable = true,
	},
	filetypes = {
		'html', 'htmldjango',
	},
})
