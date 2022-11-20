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
    },

    filters = {
        dotfiles = true,
        custom = {
            "^\\.git"
        },
    },
})
