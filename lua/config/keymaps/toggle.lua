local util = require("utils")
local keymap = util.keymap

local function toggle_keymap(lhs, rhs, desc)
	local prefix = [[\]]
	keymap("n", prefix .. lhs, rhs, { desc = desc })
end

toggle_keymap("c", "<Cmd>setlocal cursorline!<CR>", "Toggle 'cursorline'")
toggle_keymap("C", "<Cmd>setlocal cursorcolumn!<CR>", "Toggle 'cursorcolumn'")
toggle_keymap("h", "<Cmd>let v:hlsearch = 1 - v:hlsearch<CR>", "Toggle search highlight")
toggle_keymap("i", "<Cmd>setlocal ignorecase!<CR>", "Toggle 'ignorecase'")
toggle_keymap("l", "<Cmd>setlocal list!<CR>", "Toggle 'list'")
toggle_keymap("n", "<Cmd>setlocal number!<CR>", "Toggle 'number'")
toggle_keymap("r", "<Cmd>setlocal relativenumber!<CR>", "Toggle 'relativenumber'")
toggle_keymap("s", "<Cmd>setlocal spell!<CR>", "Toggle 'spell'")
toggle_keymap("w", "<Cmd>setlocal wrap!<CR>", "Toggle 'wrap'")
