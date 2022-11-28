-- --------------------------------- LSP & Mason -------------------------------- --
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
    config = 'require(P_CONFIGS .. "lsp.lspconfig")',
})

use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = 'require(P_CONFIGS .. "lsp.null-ls")'
})

use({
    "jayp0521/mason-null-ls.nvim",
    config = 'require("mason-null-ls").setup()',
})

use({
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = 'require(P_CONFIGS .. "lsp.mason")',
})

use({
    "ray-x/lsp_signature.nvim",
    config = 'require(P_CONFIGS .. "lsp.signature")',
})

use({
    "glepnir/lspsaga.nvim",
    config = 'require(P_CONFIGS .. "lsp.lspconfig.lspsaga")',
})

use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = 'require("trouble").setup({})',
})
