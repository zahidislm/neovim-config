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
            config = 'require(P_CONFIGS .. "completion.luasnip")',
        },
        { "saadparwaiz1/cmp_luasnip" },
        {
            "windwp/nvim-autopairs",
            config = 'require(P_CONFIGS .. "completion.autopair")',
        }
    },
    config = 'require(P_CONFIGS .. "completion.cmp")',
})
