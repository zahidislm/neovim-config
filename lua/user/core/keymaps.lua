local e_opts = { expr = true }
local se_opts = { silent = true, expr = true }

-- Open url at cursor in browser
kmap {
    key = "<Leader>ou",
    cmd = function()
        local pos = vim.api.nvim_win_get_cursor(0)
        local col, _ = vim.api.nvim_get_current_line():find("https?")
        if not col then
            return
        end
        vim.api.nvim_win_set_cursor(0, { pos[1], col - 1 })
        open_url(vim.fn.expand("<cfile>"))
        vim.api.nvim_win_set_cursor(0, pos)
    end
}

-- Open plugin repository at cursor in browser
kmap {
    key = "<Leader>or",
    cmd = function()
        open_url(vim.fn.expand("<cfile>"), [[https://github.com/]])
    end
}

-- Replace word under cursor
kmap { key = "<F2>", cmd = [[:%s/\<<C-r><C-w>\>/]] }
kmap {
    mode = "v",
    key = "<F2>",
    cmd = [[<Esc>:%s/<C-r>=EscapeString(GetVisualSelection())<CR>/]]
}

-- Save file
kmap { key = "<C-s>", cmd = "<cmd>update!<CR>" }
kmap { mode = "i", key = "<C-s>", cmd = "<Esc><cmd>update!<CR>" }

-- Save and reload module
kmap { key = "<C-S-s>", cmd = "<cmd>lua save_reload_module()<CR>" }

-- Format entire document
kmap { key = "<C-f>", cmd = "gg=G''zz<Esc>" }

-- Toggle spell
kmap { key = "<F10>", cmd = "<cmd>setlocal spell!<CR>" }

-- Remove highlight
kmap { key = "<Leader>h", cmd = "<cmd>nohl<CR>" }

-- map $ to g_
kmap { key = "$", cmd = "g_" }
kmap { mode = "v", key = "$", cmd = "g_" }

-- Yank till line end
kmap { key = "Y", cmd = '"+yg_' }

-- Always yank to clipboard
kmap { key = "y", cmd = '"+y' }
kmap { mode = "v", key = "y", cmd = '"+y' }

-- Paste from system clipboard in insert/select mode
kmap { mode = "i", key = "<C-v>", cmd = "<C-R>+" }
kmap { mode = "s", key = "<C-v>", cmd = "<BS>i<C-R>+" }

-- Toggle paste mode and paste from system clipboard
kmap { key = "<Leader>v", cmd = '<F12>"+P<F12>' }
kmap { mode = "i", key = "<Leader>v", cmd = '<ESC><F12>"+P<F12>i' }

-- Move to line end
kmap { mode = "i", key = "<C-a>", cmd = "<Esc>g_a" }

-- Display line movements
kmap {
    key = "j",
    cmd = "v:count == 0 ? 'gj' : 'j'",
    opts = e_opts
}

kmap {
    key = "k",
    cmd = "v:count == 0 ? 'gk' : 'k'",
    opts = e_opts
}

-- Fix accidental line joining during visual block selection
kmap { mode = "v", key = "J", cmd = "j" }
kmap { mode = "v", key = "K", cmd = "k" }

-- Correct previous bad word in insert mode
kmap { mode = "i", key = "<C-z>", cmd = "<C-g>u<Esc>[s1z=`]a<C-g>u" }
-- Correct word under cursor
kmap { key = "<C-z>", cmd = "1z=<Esc>" }

-- Delete previous word
kmap { mode = "i", key = "<C-BS>", cmd = "<C-w>" }
-- Delete next word
kmap { mode = "i", key = "<C-Del>", cmd = "<C-o>dW" }

-- Indenting
kmap { key = "<M-]>", cmd = ">>" }
kmap { key = "<M-[>", cmd = "<<" }

-- Continuous visual shifting https://superuser.com/q/310417/736190
kmap { mode = "x", key = "<M-]>", cmd = ">gv" }
kmap { mode = "x", key = "<M-[>", cmd = "<gv" }

-- Window switching
kmap { key = "<C-h>", cmd = "<C-w>h" }
kmap { key = "<C-l>", cmd = "<C-w>l" }
kmap { key = "<C-k>", cmd = "<C-w>k" }
kmap { key = "<C-j>", cmd = "<C-w>j" }

-- Disable word search on shift mouse
kmap { mode = "", key = "<S-LeftMouse>", cmd = "<nop>" }
kmap { mode = "", key = "<S-LeftDrag>", cmd = "<nop>" }

-- Command mode movement
kmap { mode = "c", key = "<C-h>", cmd = "<Left>" }
kmap { mode = "c", key = "<C-l>", cmd = "<Right>" }

-- Duplicate line
kmap { key = "<M-d>", cmd = "<cmd>t.<CR>" }
kmap { mode = "i", key = "<M-d>", cmd = "<Esc><cmd>t.<CR>gi" }

-- Move line / block
kmap { key = "<A-j>", cmd = ":m .+1<CR>==" }
kmap { key = "<A-k>", cmd = ":m .-2<CR>==" }
kmap { mode = "i", key = "<A-j>", cmd = "<Esc>:m .+1<CR>==gi" }
kmap { mode = "i", key = "<A-k>", cmd = "<Esc>:m .-2<CR>==gi" }
kmap { mode = "v", key = "<A-j>", cmd = ":m '>+1<CR>gv-gv" }
kmap { mode = "v", key = "<A-k>", cmd = ":m '<-2<CR>gv-gv" }

-- Toggle wrap
kmap { key = "<F11>", cmd = "<cmd>setlocal linebreak! wrap!<CR>" }

-- Center cursor after traversing search
kmap { key = "n", cmd = "nzz" }
kmap { key = "N", cmd = "Nzz" }

-- Toggle fold (single level)
kmap {
    key = "<Space>",
    cmd = "foldlevel('.') ? 'za' : '<Space>'",
    opts = se_opts
}

-- Handle save & close, force close when multiple buffers are active
kmap {
    key = "ZZ",
    cmd = "len(getbufinfo({'buflisted':1})) > 1 ? '<cmd>wqall<CR>' : '<cmd>wq<CR>'",
    opts = se_opts
}

kmap {
    key = "ZQ",
    cmd = "len(getbufinfo({'buflisted':1})) > 1 ? '<cmd>qall!<CR>' : '<cmd>q!<CR>'",
    opts = se_opts
}

-- Undo break points
local break_points = { ".", ",", "!", "?", "=", "-", "_" }
for _, v in pairs(break_points) do
    kmap { mode = "i", key = tostring(v), cmd = v .. "<C-g>u" }
end
