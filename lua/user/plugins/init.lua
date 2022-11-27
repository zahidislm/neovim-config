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
        "williamboman/mason.nvim",
        config = 'require("mason").setup()'
    })

    use({
        "williamboman/mason-lspconfig.nvim",
        config = 'require("mason-lspconfig").setup()',
    })

    use({
        "neovim/nvim-lspconfig",
        requires = { "hrsh7th/cmp-nvim-lsp" },
        config = 'require("user.plugins.config.lspconfig")',
    })

    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = 'require("user.plugins.config.null-ls")'
    })

    use({
        "jayp0521/mason-null-ls.nvim",
        config = 'require("mason-null-ls").setup()',
    })

    use({
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = 'require("user.plugins.config.mason")',
    })

    use({
        "ray-x/lsp_signature.nvim",
        config = 'require("user.plugins.config.signature")',
    })

    use({
        "glepnir/lspsaga.nvim",
        config = 'require("user.plugins.config.lspconfig.lspsaga")',
    })

    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = 'require("trouble").setup({})',
    })
    -- ----------------------------- Completion ----------------------------- --
    use({
        "hrsh7th/nvim-cmp",
        wants = { "LuaSnip" },
        requires = {
            { "hrsh7th/cmp-nvim-lsp", requires = "neovim/nvim-lspconfig"},
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-omni" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            {
                "L3MON4D3/LuaSnip",
                wants = "friendly-snippets",
                requires = {
                    "rafamadriz/friendly-snippets",
                },
                config = 'require("user.plugins.config.luasnip")',
            },
            { "saadparwaiz1/cmp_luasnip" },
            {
                "windwp/nvim-autopairs",
                config = 'require("user.plugins.config.autopair")',
            }
        },
        config = 'require("user.plugins.config.cmp")',
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
    -- ------------------------------ Features ------------------------------ --
    use({
        "skywind3000/asyncrun.vim",
        cmd = { "AsyncRun", "AsyncStop" },
    })

    use({
        "numToStr/Comment.nvim",
        config = 'require("user.plugins.config.comment")',
    })

    use({
        "nvim-tree/nvim-tree.lua",
        requires = {
            "nvim-tree/nvim-web-devicons",
        },
        config = 'require("user.plugins.config.nvim-tree")',
    })

    use({
        "ggandor/leap.nvim",
        config = 'require("leap").add_default_mappings()'
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
    -- --------------------------------- QOL -------------------------------- --
    use({
        "tpope/vim-repeat",
    })

    use({
        "Darazaki/indent-o-matic",
        config = 'require("indent-o-matic").setup {}'
    })

    -- Automatic initial plugin installation
    if packer_bootstrap then
        packer.sync()
    end
end)
