return {
	"gbprod/yanky.nvim",
	opts = {
		highlight = { timer = 200 },
	},
	keys = function()
		return require("plugins.yanky.keys")
	end,
}
