-- Compile on change autocmd{{{
    local group = vim.api.nvim_create_augroup("packer_compile_onchange", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
        command = [[source <afile> | PackerCompile]],
        desc = "Run ':PackerCompile' when this file changes.",
        group = group,
        pattern = "*/plugins/init.lua",
    }) --}}}

    -- Install packer.nvim in "start" folder i.e., not lazy loaded {{{
    local install_path = PACKER_PATH .. "\\start\\packer.nvim"
    local packer_bootstrap

    -- Check if packer.nvim is already installed
    local present, packer = pcall(require, "packer")
    if not present and vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        -- Install packer.nvim
        packer_bootstrap = vim.fn.system({
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path,
        })

        -- Check for installation success
        vim.cmd("packadd packer.nvim")

        present, packer = pcall(require, "packer")
        if present then
            vim_notify("packer.nvim installation successful.", vim.log.levels.INFO)
        else
            vim_notify("packer.nvim installation failed.", vim.log.levels.ERROR)
            return
        end
    end --}}}

    -- Initialize packer.nvim {{{
    packer.init({
        max_jobs = 8,
        compile_path = CONFIG_PATH .. "/plugin/packer_compiled.lua", -- for impatient caching
        snapshot = "latest",
        snapshot_path = CONFIG_PATH .. "/packer_snapshot",
        display = {
            open_fn = function()
                return require("packer.util").float({ border = "single" })
            end,
            prompt_border = "single",
            working_sym = "",
            error_sym = "",
            done_sym = "",
        },
        auto_clean = true,
        compile_on_sync = true,
        autoremove = true,
    }) --}}}

    -- Plugin list
    local use = packer.use
    return packer.startup(function()
        -- ------------------------------- Packer ------------------------------- --
        use({
            "wbthomason/packer.nvim",
        })

        -- ------------------------------ Impatient ----------------------------- --
        use({
            "lewis6991/impatient.nvim",
        })

        -- ------------------------------- Themes ------------------------------- --
        use({
            "projekt0n/github-nvim-theme",
            config = 'require("user.plugins.config.theme")',
        })

        -- -------------------------------- Looks ------------------------------- --
        use({
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            requires = {
                { "p00f/nvim-ts-rainbow" },
                { "nvim-treesitter/nvim-treesitter-textobjects" },
                { "nvim-treesitter/nvim-treesitter-refactor" },
                { "nvim-treesitter/nvim-treesitter-context" },
            },
            config = 'require("user.plugins.config.treesitter")',
        })
        use({
            "kyazdani42/nvim-web-devicons"
        })
        use({
            "lukas-reineke/indent-blankline.nvim",
            config = 'require("user.plugins.config.indentline")',
        })

        -- --------------------------------- LSP -------------------------------- --

        use({
            {
                "williamboman/mason.nvim",
                config = 'require("mason").setup()',
            },
            {
                "williamboman/mason-lspconfig.nvim",
                config = 'require("user.plugins.config.lspconfig.mason")',
            },
            {
                "neovim/nvim-lspconfig",
                requires = { "hrsh7th/cmp-nvim-lsp" },
                config = 'require("user.plugins.config.lspconfig")',
            },
            after = "nvim-cmp"
        })
        use({
            "ray-x/lsp_signature.nvim",
            after = "nvim-lspconfig",
            config = 'require("user.plugins.config.others").lsp_signature()',
        })
        use({
            "jose-elias-alvarez/null-ls.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = 'require("user.plugins.config.null_ls")',
        })
        use({
            "glepnir/lspsaga.nvim",
            config = 'require("user.plugins.config.lspconfig.lspsaga")',
        })
        use({
            "folke/trouble.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = function()
                require("trouble").setup({})
            end,
        })
        -- ----------------------------- Completion ----------------------------- --
        use({
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            requires = {
                { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp", requires = "neovim/nvim-lspconfig" },
                { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
                { "hrsh7th/cmp-omni", after = "nvim-cmp" },
                { "hrsh7th/cmp-path", after = "nvim-cmp" },
                { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
                { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
                { "dcampos/nvim-snippy", after = "nvim-cmp" },
                { "dcampos/cmp-snippy", after = "nvim-cmp" },
            },
            config = 'require("user.plugins.config.cmp")',
        })

        -- ------------------------------ Features ------------------------------ --
        use({
            "skywind3000/asyncrun.vim",
            cmd = { "AsyncRun", "AsyncStop" },
        })
        use({
            "terrortylor/nvim-comment",
            cmd = "CommentToggle",
            keys = { { "n", "<C-/>" }, { "v", "<C-/>" }, { "i", "<C-/>" }, { "n", "gc" }, { "v", "gc" } },
            config = 'require("user.plugins.config.others").nvim_comment()',
        })
        use({
            "jiangmiao/auto-pairs",
            config = 'require("user.plugins.config.others").autopairs()',
        })
        use({
            "nvim-tree/nvim-tree.lua",
            requires = {
                "nvim-tree/nvim-web-devicons",
            },
            config = 'require("user.plugins.config.nvimtree")',
        })
        use({
            "ggandor/lightspeed.nvim"
        })
        use({
            "kylechui/nvim-surround",
            config = function()
                require("nvim-surround").setup({
                    highlight = { duration = 500 },
                    move_cursor = false,
                })
            end,
        })
        use({
            "mg979/vim-visual-multi",
            keys = { { "n", "<C-n>" }, { "n", "<C-Down>" }, { "n", "<C-Up>" } },
            config = function()
                vim.g.VM_set_statusline = 0
            end,
        })

        -- ------------------------------ Telescope ----------------------------- --
        use({
            "nvim-telescope/telescope.nvim",
            branch = "0.1.x",
            requires = {
                { "nvim-lua/plenary.nvim" },
                { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
            },
            config = 'require("user.plugins.config.telescope")'
        })

        -- ------------------------- Buffer, Statusline ------------------------- --
        use({
            "nvim-lualine/lualine.nvim",
            requires = {
                {"kyazdani42/nvim-web-devicons"},
                {
                    "lewis6991/gitsigns.nvim",
                    config = 'require("user.plugins.config.gitsigns")'
                }
            },
            config = 'require("user.plugins.config.lualine")'
        })
        use({
            "akinsho/bufferline.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = 'require("user.plugins.config.bufferline")'
        })
        -- --------------------------------- QOL -------------------------------- --
        use({
            "tpope/vim-repeat",
        })
        use({
            "Konfekt/FastFold",
            config = 'require("user.plugins.config.others").fastfold()',
        })

        -- Automatic initial plugin installation
        if packer_bootstrap then
            packer.sync()
        end
    end)
