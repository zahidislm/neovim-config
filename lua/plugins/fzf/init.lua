return {
	{
		"ibhagwan/fzf-lua",
		name = "fzf",
		opts = function()
			return require("plugins.fzf.config")
		end,
		config = function(_, opts)
			local fzf = require("fzf-lua")
			fzf.setup(opts)
			fzf.register_ui_select(function(_, items)
				local min_h, max_h = 0.15, 0.70
				local h = (#items + 4) / vim.o.lines
				if h < min_h then
					h = min_h
				elseif h > max_h then
					h = max_h
				end
				return { winopts = { height = h, width = 0.5, row = 0.45 } }
			end)
		end,
		keys = function()
			return require("plugins.fzf.keys").setup()
		end,
	},
}
