return {
	{
		"EdenEast/nightfox.nvim",
		name = "default-colorscheme",
		lazy = false,
		opts = {
			options = {
				dim_inactive = true,
				module_default = false,
				inverse = { match_paren = true },

				modules = {
					cmp = true,
					diagnostic = { enable = true, background = true },
					gitsigns = true,
					mini = true,
					native_lsp = { enable = true, background = true },
					treesitter = true,
					whichkey = true,
				},
			},
			groups = { all = require("plugins.ui.config.highlights").setup() },
		},
		config = function(_, opts)
			require("nightfox").setup(opts)
		end,
		priority = 1000,
	},

	{
		"JManch/sunset.nvim",
		lazy = false,
		dependencies = { "default-colorscheme" },
		opts = {
			latitude = 43.7001,
			longitude = -79.4163,
			day_callback = function()
				vim.cmd("colorscheme dayfox")
			end,
			night_callback = function()
				vim.cmd("colorscheme carbonfox")
			end,
		},
		priority = 900,
	},

	{
		"zahidislm/zahidvim-ui.nvim",
		name = "UI",
		lazy = false,
		dependencies = {
			"rebelot/heirline.nvim",
			"nvim-tree/nvim-web-devicons",
			"GitSigns",
		},
		opts = {
			ui = {
				icons = {
					enable_nerdfont = true,
					enable_devicons = true,
				},
			},
		},
		priority = 800,
	},

	{
		"utilyre/barbecue.nvim",
		dependencies = { "SmiteshP/nvim-navic" },
		opts = {
			show_modified = true,
			create_autocmd = false,
		},
		config = function(_, opts)
			require("barbecue").setup(opts)

			vim.api.nvim_create_autocmd({
				"WinScrolled",
				"BufWinEnter",
				"CursorHold",
				"InsertLeave",
				"BufModifiedSet",
			}, {
				group = vim.api.nvim_create_augroup("barbecue.updater", {}),
				callback = function()
					require("barbecue.ui").update()
				end,
			})
		end,
		event = "BufReadPre",
	},
}
