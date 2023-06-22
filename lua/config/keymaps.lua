local util = require("utils")
local keymap = util.keymap

local norm = "n"
local vis = "v"
local ins = "i"
local norm_vis = { "n", "v" }
local ins_norm = { "i", "n" }

local e_opts = { expr = true }

-- default replcements
keymap(norm_vis, ";", ":", { silent = false })
keymap(norm, "x", '"_x') -- delete without putting into clipboard
keymap(norm_vis, "c", '"_c') -- change without putting into clipboard
keymap(norm_vis, "C", '"_C') -- change til EOL without putting into clipboard
keymap(vis, "d", '"_d') -- delete without putting into clipboard
keymap(vis, "D", "d") -- original d keymap

-- line pos movement
keymap(ins, "<M-H>", "<Esc>_i", { desc = "Move to the start of line" })
keymap(ins, "<M-L>", "<Esc>g_a", { desc = "Move to the end of line" })
keymap(norm, "H", "^") -- move to start of line
keymap(norm, "L", "$") -- move to end of line

-- clear search with esc
keymap(ins_norm, "<esc>", "<Cmd>noh<CR><Esc>")
keymap(norm, "gw", "*N")
keymap("x", "gw", "*N")

-- n to always search forward and N backward
keymap(norm, "n", "'Nn'[v:searchforward]", e_opts)
keymap("x", "n", "'Nn'[v:searchforward]", e_opts)
keymap("o", "n", "'Nn'[v:searchforward]", e_opts)
keymap(norm, "N", "'nN'[v:searchforward]", e_opts)
keymap("x", "N", "'nN'[v:searchforward]", e_opts)
keymap("o", "N", "'nN'[v:searchforward]", e_opts)

-- Add undo break-points
keymap(ins, ",", ",<C-g>u")
keymap(ins, ".", ".<C-g>u")
keymap(ins, ";", ";<C-g>u")

-- code folding
keymap(norm, "<Leader><Space>", "za", { desc = "Toggle code folding" })

-- Indenting
keymap(norm, "<A-[>", "<<", { desc = "Indent backwards" })
keymap(norm, "<A-]>", ">>", { desc = "Indent forwards" })
keymap(vis, "<A-[>", "<gv", { desc = "Indent backwards" })
keymap(vis, "<A-]>", ">gv", { desc = "Indent forwards" })

-- Quickfix
keymap(norm, "qf", "<Cmd>copen<CR>", { desc = "open quickfix window" })
keymap(norm, "qfc", "<Cmd>call setqflist([], 'r')<CR>", { desc = "Clear current quickfix list" })
keymap(norm, "<Left>", "<Cmd>cnext<CR>", { desc = "Swap to next quickfix list" })
keymap(norm, "<Right>", "<Cmd>cprev<CR>", { desc = "Swap to previous quickfix list" })

-- Utils
keymap(ins, "<M-BS>", "<Esc>cvb", { desc = "delete previous word" })
keymap(norm, "<C-q>", "<Cmd>q!<CR>", { desc = "Force quit" })
keymap(ins, "<M-d>", "<Esc>yypgi", { desc = "Duplicates line" })

-- LEADER KEYMAPS --
-- window management
keymap(norm, "<Leader>ww", "<C-W>p", { desc = "other-window" })
keymap(norm, "<Leader>wd", "<C-W>c", { desc = "delete-window" })
keymap(norm, "<Leader>w2", "<C-W>v", { desc = "layout-double-columns" })
keymap(norm, "<Leader>wh", "<C-W>h", { desc = "window-left" })
keymap(norm, "<Leader>wj", "<C-W>j", { desc = "window-below" })
keymap(norm, "<Leader>wl", "<C-W>l", { desc = "window-right" })
keymap(norm, "<Leader>wk", "<C-W>k", { desc = "window-up" })
keymap(norm, "<Leader>w=", "<C-W>=", { desc = "balance-window" })
keymap(norm, "<Leader>ws", "<C-W>s", { desc = "split-window-below" })
keymap(norm, "<Leader>wv", "<C-W>v", { desc = "split-window-right" })

-- Search & Replace
keymap(norm, "c*", "*``cgn", { desc = "Renames cursorword downward" })
keymap(vis, "c*", '"fy/\\V<C-R>f<CR>``cgn', { desc = "Renames cursorword downward" })
keymap(norm, "c#", "#``cgN", { desc = "Renames cursorword upwards" })
keymap(vis, "c#", '"fy/\\V<C-R>f<CR>``cgN', { desc = "Renames cursorword upwards" })
keymap(norm, "<Leader>r", [["zyiw:%s/<C-r>z//g<Left><Left>]], { desc = "Replaces all instance of cursorword" })
keymap(vis, "<Leader>r", [["zy:%s/<C-r>z//g<Left><Left>]], { desc = "Replaces all instance of cursorword" })

-- buffers
keymap(norm, "<Leader>bc", "<Cmd>%bd|e#|bd#<CR>", { desc = "delete all other buffers" })

-- floating terminal
keymap(norm, "<Leader>tO", function()
	util.float_term(nil, { cwd = util.get_root() })
end, { desc = "open floating term (root)" })

keymap(norm, "<Leader>to", function()
	util.float_term()
end, { desc = "open floating term (cwd)" })

keymap("t", "<Esc><Esc>", "<C-\\><c-n>", { desc = "Enter Normal Mode" })
