-- Lsp finder find the symbol definition implement reference
-- if there is no implement it will hide
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
kmap { key = "gh", cmd = "<cmd>Lspsaga lsp_finder<CR>" }

-- Code action
kmap { mode = { "n", "v" }, key = "<Leader>ca", cmd = "<cmd>Lspsaga code_action<CR>" }

-- Rename
kmap { key = "gr", cmd = "<cmd>Lspsaga rename<CR>" }

-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
kmap { key = "gd", cmd = "<cmd>Lspsaga peek_definition<CR>" }

-- Show line diagnostics
kmap { key = "<Leader>ld", cmd = "<cmd>Lspsaga show_line_diagnostics<CR>" }

-- Show cursor diagnostic
kmap { key = "<Leader>cd", cmd = "<cmd>Lspsaga show_cursor_diagnostics<CR>" }

-- Diagnsotic jump can use `<c-o>` to jump back
kmap { key = "[e", cmd = "<cmd>Lspsaga diagnostic_jump_prev<CR>" }
kmap { key = "]e", cmd = "<cmd>Lspsaga diagnostic_jump_next<CR>" }

-- Only jump to error
kmap { key = "[E", cmd = function()
    require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end }

kmap { key = "]E", cmd = function()
    require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end }

-- Outline
kmap { key = "<Leader>ol", cmd = "<cmd>LSoutlineToggle<CR>" }

-- Hover Doc
kmap { key = "<Leader>K", cmd = "<cmd>Lspsaga hover_doc<CR>" }

-- Float terminal
kmap { key = "<A-d>", cmd = "<cmd>Lspsaga open_floaterm<CR>" }

-- close floaterm
kmap { mode = "t", key = "<A-d>", cmd = [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]] }
