-- ----------------------------- Completion ----------------------------- --
use({
    "rafamadriz/friendly-snippets",
    module = { "cmp", "cmp_nvim_lsp" },
    event = { "InsertEnter" },
})

use({
    "hrsh7th/nvim-cmp",
    after = "friendly-snippets",
    event = "InsertEnter *",
    config = 'require(P_CONFIGS .. "completion")',
})

use({
    "L3MON4D3/LuaSnip",
    wants = "friendly-snippets",
    after = "nvim-cmp",
    config = 'require("luasnip.loaders.from_vscode").lazy_load()',
})

use({
    "saadparwaiz1/cmp_luasnip",
    after = "LuaSnip",
})

use({
    "hrsh7th/cmp-nvim-lua",
    after = "cmp_luasnip",
})

use({
    "hrsh7th/cmp-nvim-lsp",
    after = "cmp-nvim-lua",
})

use({
    "hrsh7th/cmp-nvim-lsp-signature-help",
    after = "cmp-nvim-lsp"
})

use({
    "hrsh7th/cmp-buffer",
    after = "cmp-nvim-lsp-signature-help",
})

use({
    "hrsh7th/cmp-path",
    after = "cmp-buffer",
})

use({
    "hrsh7th/cmp-cmdline",
    after = "cmp-path",
})

use({
    "onsails/lspkind.nvim",
    after = "cmp-cmdline",
})

use({
    "windwp/nvim-autopairs",
    after = "nvim-cmp",
    event = "InsertEnter",
    config = 'require(P_CONFIGS .. "completion.autopair")',
})
