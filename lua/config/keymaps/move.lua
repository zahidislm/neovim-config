local util = require("utils")
local keymap = util.keymap

local norm = "n"
local vis = "v"
local ins = "i"
local cmd = "c"
local norm_vis = { norm, vis }

-- move thru visible lines only
keymap(norm_vis, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
keymap(norm_vis, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- Move only sideways in command mode. Using `silent = false` makes movements
-- to be immediately shown.
keymap(cmd, "<M-h>", "<Left>", { silent = false })
keymap(cmd, "<M-l>", "<Right>", { silent = false })

-- Don't `noremap` in insert mode to have these keybindings behave exactly
-- like arrows
keymap(ins, "<M-h>", "<Left>", { noremap = false })
keymap(ins, "<M-j>", "<Down>", { noremap = false })
keymap(ins, "<M-k>", "<Up>", { noremap = false })
keymap(ins, "<M-l>", "<Right>", { noremap = false })

-- line position movement
keymap(norm, "gh", "^", { desc = "Move to the start of line" })
keymap(norm, "gl", "$", { desc = "Move to the end of line" })
