-- Keymap helper
local function keymap(mode, lhs, rhs, opts)
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})

  vim.keymap.set(mode, lhs, rhs, opts)
end

local norm = "n"
local vis = "x"
local ins = "i"

-- Add undo break-points
keymap(ins, ",", ",<C-g>u")
keymap(ins, ".", ".<C-g>u")
keymap(ins, ";", ";<C-g>u")

-- Undo all unsaved changes
keymap(norm, "U", "<Cmd>ea 1f<CR>", { desc = "Undo all unsaved changes" })

-- Redo
keymap(norm, "<C-S-r>", "<Cmd>later 1d<CR>", { desc = "Redo all changes" })

-- Yank
keymap(vis, "Y", [["+y]], { desc = "Copy selection to gui-clipboard" })
keymap(
  norm, "yY",
  [[<Cmd>let b:v=winsaveview() | keepjumps keepmarks norm! ggVG"+y | call winrestview(b:v)<CR>]],
  { desc = "Copy selection to gui-clipboard" }
)

-- Paste
keymap({ norm, vis }, "=pp", [["+P`[v`]=]], { desc = "Put from clipboard" })
keymap({ norm, vis }, "gp", "`[v`]", { desc = "Select previous paste" })
keymap({ norm, vis }, "=p", [[P`[v`]=]], { desc = "Formatted put" })

-- Split Management
keymap(norm, "|", "<Cmd>vsplit<CR>", { desc = "Vertical split" })
keymap(norm, [[\\]], "<Cmd>split<CR>", { desc = "Horizontal split" })

-- Add empty lines before and after cursor line
vim.keymap.set("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", {
  desc = "Add newline below",
})

vim.keymap.set("n", "go", "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>", {
  desc = "Add newline above",
})

-- Indenting
keymap(vis, "<<", "<gv", { desc = "Indent backwards" })
keymap(vis, ">>", ">gv", { desc = "Indent forwards" })

-- Search & Replace
keymap(norm, "c*", "*``cgn", { desc = "Renames cursorword downward" })
keymap(vis, "c*", '"fy/\\V<C-R>f<CR>``cgn', { desc = "Renames cursorword downward" })
keymap(norm, "c#", "#``cgN", { desc = "Renames cursorword upwards" })
keymap(vis, "c#", '"fy/\\V<C-R>f<CR>``cgN', { desc = "Renames cursorword upwards" })
keymap(norm, "S", [["zyiw:%s/<C-r>z//g<Left><Left>]], {
  silent = false,
  desc = "Replaces all instances of cursorword",
})

keymap(vis, "S", [["zy:%s/<C-r>z//g<Left><Left>]], {
  silent = false,
  desc = "Replaces all instances of visual selection",
})

-- Utils
keymap(norm, "<BS>", "<C-o>", { desc = "Go back to previous line." })
keymap(norm, "<Leader>q", "<Cmd>qa<CR>", { desc = "Quit Neovim" })
keymap(vis, "g/", "<esc>/\\%V", {
  silent = false,
  desc = "Search inside visual selection",
})
keymap(
  norm, "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"',
  { expr = true, replace_keycodes = false, desc = "Visually select changed text" }
)

-- Alternative way to save file
keymap(norm, "<D-s>", "<Cmd>silent! update | redraw<CR>", { desc = "Save file" })
keymap({ ins, vis }, "<D-s>", "<Esc><Cmd>silent! update | redraw<CR>", {
  desc = "Save and go to Normal mode",
})

-- Create new file
keymap(norm, "<Leader>fn", [[<Cmd>lua require("utils").smart_new_file()<CR>]], {
  desc = "Create new file",
})

-- Rename file
keymap(
  norm, "<Leader>fr", [[<Cmd>lua require("utils").rename_file()<CR>]], { desc = "Create new file" }
)

-- Clear QF/loclist
keymap(norm, "<Leader>dc", [[<Cmd>lua require("utils").empty_lists()<CR>]], {
  desc = "Empty Quickfix/Location List",
})
