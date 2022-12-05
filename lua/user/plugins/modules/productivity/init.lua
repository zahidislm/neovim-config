-- ------------------------------ Features ------------------------------ --
use({
    "numToStr/Comment.nvim",
    opt = true,
    keys = { "gc", "gcc", "gbc" },
    config = 'require("Comment").setup()',
})

use({
    "ggandor/leap.nvim",
    opt = true,
    keys = { "s", "S", "f", "F", "t", "T" },
    config = 'require("leap").add_default_mappings()'
})

use({
    "kylechui/nvim-surround",
    config = 'require("nvim-surround").setup({})',
})
-- --------------------------------- QOL -------------------------------- --
use({
    "Darazaki/indent-o-matic",
    event = "BufReadPre",
    config = 'require("indent-o-matic").setup {}'
})
