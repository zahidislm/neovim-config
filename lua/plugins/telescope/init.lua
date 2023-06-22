return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"UI",
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},

		-- Extensions
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
	},
	opts = function()
		return require("plugins.telescope.config")
	end,
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)

		-- Load extensions
		local extensions = { "fzf", "file_browser", "ui-select" }
		pcall(function()
			for ext = 1, #extensions do
				telescope.load_extension(extensions[ext])
			end
		end)
	end,
	branch = "0.1.x",
	cmd = { "Telescope" },
	keys = function()
		return require("plugins.telescope.keys")
	end,
}
