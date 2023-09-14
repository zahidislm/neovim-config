local util = require("utils")
local keymap = util.keymap

local norm = "n"
local vis = "v"
local ins = "i"

-- Add undo break-points
keymap(ins, ",", ",<C-g>u")
keymap(ins, ".", ".<C-g>u")
keymap(ins, ";", ";<C-g>u")

-- code folding
keymap(norm, "<Leader><Space>", "za", { desc = "Toggle code folding" })

-- Indenting
keymap(vis, "<<", "<gv", { desc = "Indent backwards" })
keymap(vis, ">>", ">gv", { desc = "Indent forwards" })

-- Search & Replace
keymap(norm, "c*", "*``cgn", { desc = "Renames cursorword downward" })
keymap(vis, "c*", '"fy/\\V<C-R>f<CR>``cgn', { desc = "Renames cursorword downward" })
keymap(norm, "c#", "#``cgN", { desc = "Renames cursorword upwards" })
keymap(vis, "c#", '"fy/\\V<C-R>f<CR>``cgN', { desc = "Renames cursorword upwards" })
keymap(norm, "cA", [["zyiw:%s/<C-r>z//g<Left><Left>]], { silent = false, desc = "Replaces all instance of cursorword" })
keymap(vis, "cA", [["zy:%s/<C-r>z//g<Left><Left>]], { silent = false, desc = "Replaces all instance of cursorword" })

-- Utils
keymap(ins, "<M-BS>", [[<Esc>"_cvb]], { desc = "delete previous word" })
keymap(norm, "<C-q>", "<Cmd>q<CR>", { desc = "Force quit" })
keymap(norm, "q!", "<Cmd>q!<CR>", { desc = "Force quit" })
keymap(vis, "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })
keymap(
	norm,
	"gV",
	'"`[" . strpart(getregtype(), 0, 1) . "`]"',
	{ expr = true, replace_keycodes = false, desc = "Visually select changed text" }
)

-- Alternative way to save and exit in Normal mode.
-- NOTE: Adding `redraw` helps with `cmdheight=0` if buffer is not modified
keymap(norm, "<C-s>", "<Cmd>silent! update | redraw<CR>", { desc = "Save" })
keymap({ ins, vis }, "<C-s>", "<Esc><Cmd>silent! update | redraw<CR>", { desc = "Save and go to Normal mode" })
