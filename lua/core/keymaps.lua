local wk = require("which-key")
local function map(mode, lhs, rhs, opts)
	opts = opts or { silent = true }

	vim.keymap.set(mode, lhs, rhs, opts)
end

local norm = "n"
local vis = "v"
local ins = "i"
local norm_vis = { "n", "v" }
local ins_norm = { "i", "n" }

local se_opts = { silent = true, expr = true }

-- default replcements
map(norm_vis, ";", ":", { silent = false })
map(norm_vis, "x", '"_x') -- delete without putting into clipboard
map(norm, "j", "v:count == 0 ? 'gj' : 'j'", se_opts) -- move down respecting folds
map(norm, "k", "v:count == 0 ? 'gk' : 'k'", se_opts) -- move up respecting folds

-- move lines up
map(norm, "<A-j>", ":m .+1<CR>==")
map(vis, "<A-j>", ":m '>+1<CR>gv=gv")
map(ins, "<A-j>", "<Esc>:m .+1<CR>==gi")
-- move lines down
map(norm, "<A-k>", ":m .-2<CR>==")
map(vis, "<A-k>", ":m '<-2<CR>gv=gv")
map(ins, "<A-k>", "<Esc>:m .-2<CR>==gi")

-- insert movement
map(ins, "<C-a>", "<Esc>_i", { silent = true, desc = "Move to the start of line" })
map(ins, "<C-e>", "<Esc>g_a", { silent = true, desc = "Move to the end of line" })

-- moving between windows
map(norm, "<C-h>", "<C-w>h", { silent = true, desc = "Move to window on left" })
map(norm, "<C-l>", "<C-w>l", { silent = true, desc = "Move to window on right" })
map(norm, "<C-j>", "<C-w>j", { silent = true, desc = "Move to window on bottom" })
map(norm, "<C-k>", "<C-w>k", { silent = true, desc = "Move to window on top" })

-- clear search with esc
map(ins_norm, "<esc>", "<cmd>noh<cr><esc>")
map(norm, "gw", "*N")
map("x", "gw", "*N")

-- n to always search forward and N backward
map(norm, "n", "'Nn'[v:searchforward]", se_opts)
map("x", "n", "'Nn'[v:searchforward]", se_opts)
map("o", "n", "'Nn'[v:searchforward]", se_opts)
map(norm, "N", "'nN'[v:searchforward]", se_opts)
map("x", "N", "'nN'[v:searchforward]", se_opts)
map("o", "N", "'nN'[v:searchforward]", se_opts)

-- Add undo break-points
map(ins, ",", ",<c-g>u")
map(ins, ".", ".<c-g>u")
map(ins, ";", ";<c-g>u")

-- save in insert mode
map(ins, "<C-s>", "<cmd>:w<cr><esc>", { silent = false })
map(norm, "<C-s>", "<cmd>:w<cr><esc>", { silent = false })
map(norm, "<C-c>", "<cmd>normal ciw<cr>a", { silent = false })

-- replace word under cursor
map(norm, "rp", [[:%s/\<<C-r><C-w>\>/]], { desc = "Replace word under cursor" })
map(vis, "rp", [[<Esc>:%s/<C-r>=EscapeString(GetVisualSelection())<CR>]], { desc = "Replace word under cursor" })

-- code folding
map(norm, "ff", "za", { silent = true, desc = "Toggle code folding" })

-- Indenting
map(norm, "<A-[>", "<<", { silent = true, desc = "Indent backwards" })
map(norm, "<A-]>", ">>", { silent = true, desc = "Indent forwards" })
map(vis, "<A-[>", "<gv", { silent = true, desc = "Indent backwards" })
map(vis, "<A-]>", ">gv", { silent = true, desc = "Indent forwards" })

-- makes * and # work on visual mode too.
vim.cmd([[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction
  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]])

local leader_keymaps = {
	["w"] = {
		name = "+window",
		["w"] = { "<C-W>p", "other-window" },
		["d"] = { "<C-W>c", "delete-window" },
		["2"] = { "<C-W>v", "layout-double-columns" },
		["h"] = { "<C-W>h", "window-left" },
		["j"] = { "<C-W>j", "window-below" },
		["l"] = { "<C-W>l", "window-right" },
		["k"] = { "<C-W>k", "window-up" },
		["H"] = { "<C-W>5<", "expand-window-left" },
		["J"] = { "<cmd>resize +5<cr>", "expand-window-below" },
		["L"] = { "<C-W>5>", "expand-window-right" },
		["K"] = { "<cmd>resize -5<cr>", "expand-window-up" },
		["="] = { "<C-W>=", "balance-window" },
		["s"] = { "<C-W>s", "split-window-below" },
		["v"] = { "<C-W>v", "split-window-right" },
	},
	["b"] = {
		name = "+buffer",
		["c"] = { "<cmd>%bd|e#|bd#<cr>", "delete all other buffers" },
	},
}

wk.register(leader_keymaps, { prefix = "<leader>" })
