require("nvim-treesitter.configs").setup({
    ensure_installed = PARSERS,
    highlight = {
        enable = true,
        disable = function(lang, buf)
            local max_filesize = 750 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        additional_vim_regex_highlighting = false,
        use_languagetree = true,
        sync_install = false,
    },

    rainbow = {
        enable = true,
        extended_mode = true, -- Highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
    },

    textobjects = {
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
            include_surrounding_whitespace = true,
        },

        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },

            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },

        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = { query = "@class.outer", desc = "Next class start" },
            },

            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },

            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },

            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    },

    refactor = {
        highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true,
        },

        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "grr",
            },
        },
    },

    matchup = {
        enable = true,
        disable = { "c" },
    },
})
