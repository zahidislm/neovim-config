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
    config = 'require(P_CONFIGS .. "core.theme")',
})
-- ------------------------------ Telescope ----------------------------- --
use({
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
    config = 'require(P_CONFIGS .. "core.telescope")'
})
-- ------------------------------ Nvim-Tree ----------------------------- --
use({
    "nvim-tree/nvim-tree.lua",
    requires = {
        "nvim-tree/nvim-web-devicons",
    },
    config = 'require(P_CONFIGS .. "core.nvim-tree")',
})
