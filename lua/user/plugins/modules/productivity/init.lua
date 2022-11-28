-- ------------------------------ Features ------------------------------ --
use({
    "skywind3000/asyncrun.vim",
    cmd = { "AsyncRun", "AsyncStop" },
})

use({
    "numToStr/Comment.nvim",
    config = 'require("Comment").setup()',
})

use({
    "ggandor/leap.nvim",
    config = 'require("leap").add_default_mappings()'
})

use({
    "kylechui/nvim-surround",
    config = 'require("nvim-surround").setup({})',
})
-- --------------------------------- QOL -------------------------------- --
use({
    "tpope/vim-repeat",
})

use({
    "Darazaki/indent-o-matic",
    config = 'require("indent-o-matic").setup {}'
})
