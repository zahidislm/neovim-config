local telescope = require("telescope")
local actions = require("telescope.actions")
local utils = require("user.plugins.config.telescope.utils")

telescope.setup({
    defaults = {
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
        },
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        border = true,
        use_less = true,
        color_devicons = true,
        winblend = 0,
        entry_prefix = "  ",
        prompt_prefix = "  ",
        selection_caret = "  ",
        initial_mode = "insert",
        scroll_strategy = "cycle",
        path_display = function(_, path)
            local smart_path = require("telescope.utils").path_smart(path)
            return (smart_path:find("%.\\") or 0) + (smart_path:find("%./") or 0) == 1 and string.sub(smart_path, 3)
                or smart_path
        end,
        selection_strategy = "reset",
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        set_env = { COLORTERM = "truecolor" },
        file_ignore_patterns = utils.ignore_patterns,
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        mappings = {
            i = {
                ["<C-n>"] = false,
                ["<C-p>"] = false,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<Esc>"] = actions.close,
            },
            n = {
                ["<C-n>"] = false,
                ["<C-p>"] = false,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        },
    },
    pickers = {
        find_files = utils.dropdown(),
        oldfiles = utils.dropdown({ prompt_title = "Recent Files" }),
        git_files = utils.dropdown(),
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "ignore_case",
        },
    },
})

-- Load extensions
local extensions = { "fzf" }
pcall(function()
    for _, ext in ipairs(extensions) do
        telescope.load_extension(ext)
    end
end)

-- Mappings
require("user.plugins.mapping.telescope")
