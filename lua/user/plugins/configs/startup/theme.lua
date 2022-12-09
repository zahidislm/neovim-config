local scheme = "carbonfox"
local palette = require('nightfox.palette').load(scheme)

local light_bg = "sel1"
local dark_bg = "sel0"

local groups = {
	-- Telescope
	TelescopeBorder = { fg = dark_bg, bg = dark_bg },
	TelescopePromptBorder = { fg = light_bg, bg = light_bg },
	TelescopePromptNormal = { fg = "fg2", bg = light_bg },
	TelescopePromptPrefix = { fg = "fg2", bg = light_bg },
	TelescopeNormal = { bg = dark_bg },
	TelescopePreviewTitle = { fg = dark_bg, bg = "palette.magenta" },
	TelescopePromptTitle = { fg = dark_bg, bg = "palette.magenta" },
	TelescopePromptCounter = { bg = light_bg },
	TelescopeResultsTitle = { fg = dark_bg, bg = "palette.magenta" },
	TelescopeMatching = { fg = "palette.red" },
}

require("nightfox").setup({
	options = {
		dim_inactive = true,
	},

	groups = { all = groups }
})

vim.cmd("colorscheme " .. scheme)
