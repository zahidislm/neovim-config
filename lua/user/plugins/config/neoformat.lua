-- vim.g.neoformat_tex_latexindent = {
--     exe = "latexindent",
--     args = { "-g /dev/stderr", "2>/dev/null", "-d" },
--     stdin = 1,
-- }

vim.g.neoformat_run_all_formatters = 1
vim.g.neoformat_enabled_python = { "isort", "yapf" }
vim.g.neoformat_enabled_rust = { "rustfmt" }
