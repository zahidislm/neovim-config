-- Keymap helper
local function keymap(mode, lhs, rhs, opts)
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})

  vim.keymap.set(mode, lhs, rhs, opts)
end

local norm = "n"
local vis = "x"
local norm_vis = { norm, vis }

local e_opts = { expr = true }

-- default replacements
keymap(norm_vis, "x", [["_x]]) -- delete without putting into clipboard
keymap(norm_vis, "c", [["_c]]) -- change without putting into clipboard
keymap(norm_vis, "C", [["_C]]) -- change til EOL without putting into clipboard
keymap(norm, "*", [[m`:%s/\<<C-r><C-w>\>//n<CR>``]], { silent = true }) -- search cursorword inplace

-- NOTE: Disabled due to the use of a smooth-scroll plugin
-- keymap(norm, "<C-d>", "<C-d>zz") -- center on page down
-- keymap(norm, "<C-u>", "<C-u>zz") -- center on page up

keymap(norm, "/", "zn/", { silent = false }) -- search & pause folds
keymap(norm, "J", "mzJ`z") -- Join line while keeping the cursor in the same position

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

-- Move through quicklist
keymap(norm, "<S-Down>", "<Cmd>cnext<CR>zz") -- Go to the next quickfix item
keymap(norm, "<S-Up>", "<Cmd>cprev<CR>zz") -- Go to the previous quickfix item
