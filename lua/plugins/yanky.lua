local M = {
	"gbprod/yanky.nvim",
	event = "VeryLazy",
}

function M.config()
	require("yanky").setup({
		highlight = {
			timer = 180,
		},
	})

	local map = vim.keymap.set

	map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
	map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
	map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
	map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
	-- Yank Ring
	map("n", "<c-n>", "<Plug>(YankyCycleForward)")
	map("n", "<c-p>", "<Plug>(YankyCycleBackward)")
	-- paste after/before line
	map("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
	map("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
	-- paste w/ increasing/decreasing indent
	map("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
	map("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
	map("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
	map("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")
	-- paste w/ re-indent
	map("n", "=p", "<Plug>(YankyPutAfterFilter)")
	map("n", "=P", "<Plug>(YankyPutBeforeFilter)")
	-- telescope picker
	map("n", "<leader>P", function()
		require("telescope").extensions.yank_history.yank_history({})
	end, { desc = "Paste from Yanky" })
end

return M
