require('lualine').setup {
  options = { theme = 'ayu_mirage' },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        color = { fg = '#23922f' },
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
        'filename',
        color = { fg = '#124918' },
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
