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
			'nvim-lua/plenary.nvim'
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
		"kndndrj/nvim-dbee",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		build = function()
			require("dbee").install()
		end,
	},
}
