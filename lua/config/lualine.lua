local function parent_dir()
	local fullpath = vim.api.nvim_buf_get_name(0)
	if fullpath == '' then
		return ''
	end

	local parent = vim.fn.fnamemodify(fullpath, ':h:t')
	return parent
end


require('lualine').setup {
	options = {
		theme = 'ayu_mirage',
		-- theme = 'powerline',
		disabled_filetypes = {
			winbar = { 'neo-tree' },
		},
	},
	winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				parent_dir,
				color = { fg = '#7aa2f7' },
				icon = '',
			},
			{
				'filename',
				color = { fg = '#23922f' },
				-- file_status = false,
				newfile_status = false,
				path = 0,
			},
			{
				'filetype',
				color = { fg = '#ff8800' },
			},
		},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	inactive_winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				parent_dir,
				color = { fg = '#30406f' },
				icon = '',
			},
			{
				'filename',
				color = { fg = '#124918' },
				-- file_status = false,
			},
			{
				'filetype',
				color = { fg = '#7c4200' },
			},
		},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
}
