local wk = require("which-key")
local M = {}

local keymaps = {
    ["g"] = {
        name = "+git",
        c = { "<Cmd>Telescope git_commits<CR>", "commits" },
        b = { "<Cmd>Telescope git_branches<CR>", "branches" },
        s = { "<Cmd>Telescope git_status<CR>", "status" },
    },
    ["s"] = {
        name = "+search",
        g = { "<cmd>Telescope live_grep<cr>", "Grep" },
        b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
        s = {
          function()
            require("telescope.builtin").lsp_document_symbols({
              symbols = {
                "Class",
                "Function",
                "Method",
                "Constructor",
                "Interface",
                "Module",
                "Struct",
                "Trait",
                "Field",
                "Property",
              },
            })
          end,
          "Goto Symbol",
        },
        h = { "<cmd>Telescope command_history<cr>", "Command History" },
        m = { "<cmd>Telescope marks<cr>", "Jump to Mark" },
    },
    ["f"] = {
        name = "+file",
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        b = { "<cmd>Telescope file_browser<cr>", "opens file browser" },
    },
    ["b"] = {
        name = "+buffer",
        b = { "<cmd>Telescope buffers<cr>", "list all open buffers" }
    },
}

function M.setup()
    wk.register(keymaps, { prefix = "<leader>" })
end

return M
