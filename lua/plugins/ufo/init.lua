return {
	"kevinhwang91/nvim-ufo",
	event = "BufReadPost",
	dependencies = { "kevinhwang91/promise-async" },
	opts = {
		fold_virt_text_handler = require("plugins.ufo.utils.handler"),
		open_fold_hl_timeout = 0,
		close_fold_kinds = { "imports", "comment" },
		preview = {
			win_config = {
				border = { "", "─", "", "", "", "─", "", "" },
				winhighlight = "Normal:Folded",
				winblend = 0,
			},
		},
	},

	config = function(_, opts)
		require("ufo").setup(opts)

		-- buffer scope handler
		-- will override global handler if it is existed
		local buffer = vim.api.nvim_get_current_buf()
		require("ufo").setFoldVirtTextHandler(buffer, opts.fold_virt_text_handler)
	end,
}
