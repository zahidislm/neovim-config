local wk = require("which-key")

local keymaps = {
	["g"] = {
		name = "+git",
		["h"] = {
			name = "+hunk",
			s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage the hunk at the cursor position" },
			r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset the lines of the hunk at the cursor position" },
			S = { "<cmd>Gitsigns stage_buffer<cr>", "Stage all hunks in current buffer" },
			u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo the last call of stage_hunk" },
			R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset the lines of all hunks in the buffer" },
			p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview the hunk at the cursor position inline in the buffer" },
		},

		["t"] = {
			name = "+toggle",
			b = {
				"<cmd>Gitsigns toggle_current_line_blame<cr>",
				"Toggles a blame annotation at the end of the current line",
			},
			d = { "<cmd>Gitsigns toggle_deleted<cr>", "Toggle showing the old version of hunks inline in the buffer" },
		},
		d = { "<cmd>Gitsigns diffthis<cr>", "Perform a |vimdiff| on the given file" },
	},
}

local M = {}

function M.setup(bufopts)
	wk.register(keymaps, bufopts)
end

return M
