local wk = require("which-key")

local keymaps = {
	["g"] = {
		name = "+git",
		["h"] = {
			name = "+hunk",
			s = { "<Cmd>Gitsigns stage_hunk<CR>", "Stage the hunk at the cursor position" },
			r = { "<Cmd>Gitsigns reset_hunk<CR>", "Reset the lines of the hunk at the cursor position" },
			S = { "<Cmd>Gitsigns stage_buffer<CR>", "Stage all hunks in current buffer" },
			u = { "<Cmd>Gitsigns undo_stage_hunk<CR>", "Undo the last call of stage_hunk" },
			R = { "<Cmd>Gitsigns reset_buffer<CR>", "Reset the lines of all hunks in the buffer" },
			p = { "<Cmd>Gitsigns preview_hunk<CR>", "Preview the hunk at the cursor position inline in the buffer" },
		},

		["t"] = {
			name = "+toggle",
			b = {
				"<Cmd>Gitsigns toggle_current_line_blame<CR>",
				"Toggles a blame annotation at the end of the current line",
			},
			d = { "<Cmd>Gitsigns toggle_deleted<CR>", "Toggle showing the old version of hunks inline in the buffer" },
		},
		d = { "<Cmd>Gitsigns diffthis<CR>", "Perform a |vimdiff| on the given file" },
	},
}

local M = {}

function M.setup(bufopts)
	wk.register(keymaps, bufopts)
end

return M
