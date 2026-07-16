-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
local opt = vim.opt_local
opt.wrap = true
vim.treesitter.language.register("markdown", { "quarto", "rmd" })
