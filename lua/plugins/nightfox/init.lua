local M = {
	"EdenEast/nightfox.nvim",
	lazy = false,
}

-- NightFox Highlight Config
function M.config()
	local groups = require("plugins.nightfox.colors").highlights

	require("nightfox").setup({
		options = {
			dim_inactive = true,
			transparent = false,
		},

		groups = { all = groups },
	})

	-- Load CarbonFox Palette
	vim.cmd("colorscheme carbonfox")
end

return M
