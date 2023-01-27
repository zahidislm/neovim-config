return {
	"stevearc/dressing.nvim",

	opts = {
		select = {
			get_config = function(opts)
				opts = opts or {}

				local cfg = {
					telescope = {
						layout_config = {
							width = 80,
							height = 15,
						},
					},
				}

				if opts.kind == "codeaction" then
					cfg.telescope =
						require("telescope.themes").get_cursor({ layout_config = { height = 0.15, width = 0.45 } })
				end

				return cfg
			end,
		},

		input = {
			override = function(conf)
				conf.col = 0
				conf.row = -2
				return conf
			end,
		},
	},

	init = function()
		---@diagnostic disable-next-line: duplicate-set-field
		vim.ui.select = function(...)
			require("lazy").load({ plugins = { "dressing.nvim" } })
			return vim.ui.select(...)
		end
		---@diagnostic disable-next-line: duplicate-set-field
		vim.ui.input = function(...)
			require("lazy").load({ plugins = { "dressing.nvim" } })
			return vim.ui.input(...)
		end
	end,
}
