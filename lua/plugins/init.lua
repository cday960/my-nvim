return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"s1n7ax/nvim-window-picker",
		},
		lazy = false,
		---@module "neo-tree"
		---@type neotree.Config?
		opts = {
			-- add options here
		},
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
		},
		lazy = false
	},
	{
		"catppuccin/nvim", name = "catppuccin", priority = 1000
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {}
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		-- priority = 49,
		priority = 1,
		preview = {
			icon_provider = "devicons"
		},
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'nvim-tree/nvim-web-devicons'
		}
	},
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = false,
		tag = "v0.10.0",
		-- branch = 'main',
		build = ':TSUpdate',
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = {
			'OXY2DEV/markview.nvim',
			'nvim-lua/plenary.nvim',
		},
	},
	{
		"lewis6991/gitsigns.nvim",
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		opts = {
			-- Additional config optional
		}
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{
		'nanozuki/tabby.nvim',
		config = function()
			-- config
		end,
	},
	{
		'akinsho/toggleterm.nvim',
		version = '*',
		opts = {
			-- config
		}
	},
	{
		'neovim/nvim-lspconfig',
	},
	{
		'hrsh7th/cmp-nvim-lsp',
	},
	{
		'hrsh7th/nvim-cmp',
	},
	{
		'saadparwaiz1/cmp_luasnip',
	},
	{
		'L3MON4D3/LuaSnip',
	},
	{
		"Kurren123/mssql.nvim",
		opts = {
			-- optional
			keymap_prefix = "<leader>m"
		},
		-- optional
		dependencies = { "folke/which-key.nvim" },
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},
	{
		'windwp/nvim-ts-autotag',
		lazy = false,
	},
	{
		'mason-org/mason.nvim',
		opts = {},
	},
	{
		'stevearc/conform.nvim',
		opts = {},
	},
	{
		'smoka7/hop.nvim',
		version = "*",
		opts = {
			keys = 'etovxqpdygfblzhckisuran'
		},
	},
	{
		"nvim-treesitter/playground",
		cmd = { "TSPlaygroundToggle", "TSHighlightCaptureUnderCursor" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter.configs").setup {
				playground = {
					enable = true,
					updatetime = 25,
					persist_queries = false,
				}
			}
		end,
	},
	{
		"tpope/vim-dadbod"
	},
	{
		'kristijanhusak/vim-dadbod-ui',
		dependencies = {
			{ 'tpope/vim-dadbod',                     lazy = true },
			{ 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
		},
		cmd = {
			'DBUI',
			'DBUIToggle',
			'DBUIAddConnection',
			'DBUIFindBuffer',
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			-- vim.g.db_ui_win_position = "right"
		end
	},
	{
		'tpope/vim-dotenv'
	},
	{
		'tpope/vim-surround'
	},
	{
		'mrcjkb/rustaceanvim',
		version = '^6',
		lazy = false,
	},
	{
		'xiyaowong/transparent.nvim',
		lazy = false,
		priority = 1000
	}
	-- {
	-- 	"OXY2DEV/markview.nvim",
	-- 	lazy = false,
	-- 	priority = 49,
	-- 	preview = {
	-- 		icon_provider = "devicons"
	-- 	},
	-- 	dependencies = {
	-- 		'nvim-treesitter/nvim-treesitter',
	-- 		'nvim-tree/nvim-web-devicons'
	-- 	}
	-- }
}
