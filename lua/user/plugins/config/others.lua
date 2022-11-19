local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set
local e_opts = { expr = true }
local s_opts = { silent = true }
local se_opts = { silent = true, expr = true }

-- Contains configs for plugins
local M = {}

M.autopairs = function()
    vim.g.AutoPairsShortcutToggle = ""
    map("i", "<C-l>", "<Esc><cmd>call AutoPairsJump()<CR>a", s_opts)
end

M.nvim_comment = function()
    require("nvim_comment").setup({ comment_empty = false })
    map("i", "<C-/>", "<C-o><cmd>CommentToggle<CR><C-o>A", s_opts)
    map("n", "<C-/>", "<cmd>CommentToggle<CR>", s_opts)
    map("v", "<C-/>", ":<C-u>call CommentOperator(visualmode())<CR>", s_opts)
end

M.fastfold = function()
    vim.g.fastfold_savehook = 0
    vim.g.fastfold_fold_command_suffixes = { "x", "X" }
    vim.g.fastfold_fold_movement_commands = { "]z", "[z", "zj", "zk" }
end

M.lsp_signature = function()
    require("lsp_signature").setup({
        bind = true,
        hint_enable = false,
        hint_prefix = "",
        floating_window = true,
        hi_parameter = "ThemerHeadingH1",
        extra_trigger_chars = { "(", "," },
        handler_opts = {
            border = "single",
        },
    })
end

return M
