local util = require("utils")
local keymap = util.keymap

local norm = "n"
local vis = "v"
local norm_vis = { norm, vis }

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

-- clear search with esc
keymap(norm, "<esc>", "<Cmd>noh<CR><Esc>")

-- n to always search forward and N backward
keymap(norm, "n", "'Nn'[v:searchforward]", e_opts)
keymap(vis, "n", "'Nn'[v:searchforward]", e_opts)
keymap("o", "n", "'Nn'[v:searchforward]", e_opts)
keymap(norm, "N", "'nN'[v:searchforward]", e_opts)
keymap(vis, "N", "'nN'[v:searchforward]", e_opts)
keymap("o", "N", "'nN'[v:searchforward]", e_opts)
