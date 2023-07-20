return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	opts = {
		enable_get_fold_virt_text = true,
		provider_selector = function(bufnr, filetype, buftype)
			return { "treesitter", "indent" }
		end,
		fold_virt_text_handler = require("plugins.ufo.utils.handler"),
		open_fold_hl_timeout = 200,
		close_fold_kinds = { "imports", "comment" },
		preview = {
			win_config = {
				border = { "", "─", "", "", "", "─", "", "" },
				winhighlight = "Normal:Folded",
				winblend = 0,
			},
		},
	},
	init = function()
		vim.on_key(function(char)
			local key = vim.fn.keytrans(char)
			local search_keys = { "n", "N", "*", "#", "/", "?" }
			local search_confirmed = (key == "<CR>" and vim.fn.getcmdtype():find("[/?]") ~= nil)
			if not (search_confirmed or vim.fn.mode() == "n") then
				return
			end
			local search_key_used = search_confirmed or (vim.tbl_contains(search_keys, key))

			local pause_fold = vim.opt.foldenable:get() and search_key_used
			local unpause_fold = not (vim.opt.foldenable:get()) and not search_key_used
			if pause_fold then
				vim.opt.foldenable = false
			elseif unpause_fold then
				vim.opt.foldenable = true
				vim.cmd.normal("zv") -- after closing folds, keep the *current* fold open
			end
		end, vim.api.nvim_create_namespace("auto_pause_folds"))
	end,
	config = function(_, opts)
		require("ufo").setup(opts)

		-- buffer scope handler
		-- will override global handler if it is existed
		local buffer = vim.api.nvim_get_current_buf()
		require("ufo").setFoldVirtTextHandler(buffer, opts.fold_virt_text_handler)
	end,
	event = "VeryLazy",
}
