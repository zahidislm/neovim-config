local util = require("utils")
local keymap = util.keymap

local norm = "n"
local vis = "v"
local ins = "i"
local norm_vis = { "n", "v" }
local ins_norm = { "i", "n" }

local e_opts = { expr = true }

-- default replacements
keymap(norm, "x", [["_x]]) -- delete without putting into clipboard
keymap(norm_vis, "c", [["_c]]) -- change without putting into clipboard
keymap(norm_vis, "C", [["_C]]) -- change til EOL without putting into clipboard
keymap(norm_vis, "d", [["_d]]) -- delete without putting into clipboard
keymap(norm_vis, "D", "d") -- original d keymap
keymap(norm, "<C-d>", "<C-d>zz") -- center on page down
keymap(norm, "<C-u>", "<C-u>zz") -- center on page up
keymap(norm, "/", "zn/", { silent = false }) -- search & pause folds

-- visual mode parity
keymap(vis, "&", ":&&<cr>") -- visual execute last substitution
keymap(vis, ".", ":normal! .<cr>") -- visual execute .
keymap(vis, "@", ":normal! @") -- visual execute macro

-- line pos movement
keymap(ins, "<M-H>", "<Esc>_i", { desc = "Move to the start of line" })
keymap(ins, "<M-L>", "<Esc>g_a", { desc = "Move to the end of line" })
keymap(norm, "gh", "^", { desc = "Move to the start of line" })
keymap(norm, "gl", "$", { desc = "Move to the end of line" })

-- clear search with esc
keymap(ins_norm, "<esc>", "<Cmd>noh<CR><Esc>")

-- n to always search forward and N backward
keymap(norm, "n", "'Nn'[v:searchforward]", e_opts)
keymap(vis, "n", "'Nn'[v:searchforward]", e_opts)
keymap("o", "n", "'Nn'[v:searchforward]", e_opts)
keymap(norm, "N", "'nN'[v:searchforward]", e_opts)
keymap(vis, "N", "'nN'[v:searchforward]", e_opts)
keymap("o", "N", "'nN'[v:searchforward]", e_opts)

-- Add undo break-points
keymap(ins, ",", ",<C-g>u")
keymap(ins, ".", ".<C-g>u")
keymap(ins, ";", ";<C-g>u")

-- code folding
keymap(norm, "<Leader><Space>", "za", { desc = "Toggle code folding" })

-- Indenting
keymap(vis, "<<", "<gv", { desc = "Indent backwards" })
keymap(vis, ">>", ">gv", { desc = "Indent forwards" })

-- Utils
keymap(ins, "<M-BS>", [[<Esc>"_cvb]], { desc = "delete previous word" })
keymap(norm, "<C-q>", "<Cmd>q!<CR>", { desc = "Force quit" })
keymap(norm, "<C-Q>", "<Cmd>qa!<CR>", { desc = "Force quit all" })
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

-- Quickfix
keymap(norm, "<Leader>qo", "<Cmd>copen<CR>", { desc = "Open quickfix window" })
keymap(norm, "<Leader>qc", "<Cmd>call setqflist([], 'r')<CR>", { desc = "Clear current quickfix list" })

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
	util.float_term()
end, { desc = "open floating term (root)" })

keymap(norm, "<Leader>to", function()
	util.float_term(nil, { cwd = vim.fn.expand("%:p:h") })
end, { desc = "open floating term (cwd)" })
