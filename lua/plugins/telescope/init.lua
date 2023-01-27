return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	cmd = { "Telescope" },
	keys = function()
		return require("plugins.telescope.keys")
	end,

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},

	opts = function()
		return require("plugins.telescope.config")
	end,

	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)

		-- Load extensions
		local extensions = { "fzf", "file_browser" }
		pcall(function()
			for _, ext in ipairs(extensions) do
				telescope.load_extension(ext)
			end
		end)
	end,
}
