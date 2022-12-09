local M = {}
local mapgrp = require("legendary").itemgroups

M.init = function(b_opts)
	local gs = package.loaded.gitsigns
	local gs_mappings = {
		{
			"<leader>hs",
			":Gitsigns stage_hunk<CR>",
			description = "Stage the hunk at the cursor position",
			mode = { "n", "v" },
			opts = b_opts,
		},
		{
			"<leader>hr",
			":Gitsigns reset_hunk<CR>",
			description = "Reset the lines of the hunk at the cursor position",
			mode = { "n", "v" },
			opts = b_opts,
		},
		-- Text Object
		{
			"ih",
			":<C-U>Gitsigns select_hunk<CR>",
			mode = { "o", "x" },
			opts = b_opts,
		},
		{
			"<leader>hS",
			":Gitsigns stage_buffer<CR>",
			description = "Stage all hunks in current buffer",
			opts = b_opts,
		},
		{
			"<leader>hu",
			":Gitsigns undo_stage_hunk<CR>",
			description = "Undo the last call of stage_hunk",
			opts = b_opts,
		},
		{
			"<leader>hR",
			":Gitsigns reset_buffer<CR>",
			description = " Reset the lines of all hunks in the buffer",
			opts = b_opts,
		},
		{
			"<leader>hp",
			":Gitsigns preview_hunk<CR>",
			description = "Preview the hunk at the cursor position inline in the buffer",
			opts = b_opts,
		},
		-- Navigation
		{
			"[c",
			function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end,
			description = "Jump to the previous hunk in the current buffer",
			opts = b_opts,
		},
		{
			"]c",
			function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end,
			description = "Jump to the next hunk in the current buffer",
			opts = b_opts,
		},
		{
			"<leader>hb",
			function()
				gs.blame_line({ full = true })
			end,
			description = "Run git blame on the current line and show the results in a floating window",
			opts = b_opts,
		},
		{
			"<leader>tb",
			":Gitsigns toggle_current_line_blame<CR>",
			description = "Toggles a blame annotation at the end of the current line",
			opts = b_opts,
		},
		{
			"<leader>hd",
			":Gitsigns diffthis<CR>",
			description = "Perform a |vimdiff| on the given file",
			opts = b_opts,
		},
		{
			"<leader>td",
			":Gitsigns toggle_deleted<CR>",
			description = "Toggle showing the old version of hunks inline in the buffer",
			opts = b_opts,
		},
	}

	mapgrp({
		{
			itemgroup = "GITSIGNS",
			keymaps = gs_mappings,
			description = "Hunk management mappings for GITSIGNS plugin",
			icon = "",
		},
	})
end

return M
