local M = {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	cmd = { "Telescope" },
	keys = { "<leader>fb", "<leader>sb", "<leader>sg", "<leader>xd" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-telescope/telescope-file-browser.nvim",
	},
}

function M.config()
	-- Config telescope
	local telescope = require("telescope")
	local telescopeConfig = require("plugins.telescope.config")
	telescope.setup(telescopeConfig)

	-- Load extensions
	local extensions = { "fzf", "file_browser" }
	pcall(function()
		for _, ext in ipairs(extensions) do
			telescope.load_extension(ext)
		end
	end)

	-- Setup telescope mappings
	require("plugins.telescope.keys").setup()
end

return M
