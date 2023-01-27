return {
	"gbprod/yanky.nvim",
	keys = function()
		return require("plugins.yanky.keys")
	end,

	opts = {
		highlight = {
			timer = 180,
		},
	},
}
