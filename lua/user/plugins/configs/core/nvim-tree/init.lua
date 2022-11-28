-- Call wrapper for utils
local function custom_callback(callback_name)
    return string.format(":lua require(P_CONFIGS .. 'core.nvim-tree.utils').%s()<CR>", callback_name)
end

require("nvim-tree").setup({
    actions = {
        change_dir = {
            global = false,
        },
        open_file = {
            resize_window = true,
        },
    },

    diagnostics = {
        enable = true,
        icons = {
            hint = 'ⓘ ',
            info = 'ⓘ ',
            warning = 'ⓦ ',
            error = 'ⓧ ',
        },
    },

    update_cwd = true,
    update_focused_file = {
        enable = true,
        update_cwd = false,
    },

    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = "<c-f>", cb = custom_callback "launch_find_files" },
                { key = "<c-g>", cb = custom_callback "launch_live_grep" },
            },
        },
    },

    filters = {
        dotfiles = true,
        custom = {
            "^\\.git"
        },
    },
})

-- Mappings
require(P_MAPPINGS .. "core.nvim-tree")
