-- -------------------------------- Treesitter ------------------------------- --
use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
        { "p00f/nvim-ts-rainbow" },
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        { "nvim-treesitter/nvim-treesitter-refactor" },
        { "nvim-treesitter/nvim-treesitter-context" },
    },
    config = 'require(P_CONFIGS .. "syntax.treesitter")',
})

use({
    "lukas-reineke/indent-blankline.nvim",
    config = 'require(P_CONFIGS .. "syntax.indentline")',
})

use({ "andymass/vim-matchup" })

use({
    "kevinhwang91/nvim-ufo",
    requires = "kevinhwang91/promise-async",
    config = 'require("ufo").setup({open_fold_hl_timeout=0})'
})
