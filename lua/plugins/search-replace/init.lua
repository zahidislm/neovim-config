return {
	"roobert/search-replace.nvim",
	keys = function()
		return require("plugins.search-replace.keys")
	end,

	opts = {
		{
			default_replace_single_buffer_options = "gcI",
			default_replace_multi_buffer_options = "egcI",
		},
	},
}
