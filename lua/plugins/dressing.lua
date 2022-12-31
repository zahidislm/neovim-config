local M = { "stevearc/dressing.nvim", event = "VeryLazy" }

function M.config()
	require("dressing").setup({
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

				return cfg
			end,
		},

		input = {
			override = function(conf)
				conf.col = -1
				conf.row = 0
				return conf
			end,
		},
	})
end

return M
