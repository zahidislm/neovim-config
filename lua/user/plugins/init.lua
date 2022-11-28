-- -------------------------------- Packer Initialization ------------------------------- --

-- Compile on change autocmd {{{
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


-- -------------------------------- Plugins ------------------------------- --

-- Enable global syntax sugar for packer's use
use = packer.use

return packer.startup(function()
    -- Load CORE module
    require(P_MODULES .. "core")

    -- Load BUFFER module
    require(P_MODULES .. "buffer")

    -- Load SYNTAX module
    require(P_MODULES .. "syntax")

    -- Load LSP module
    require(P_MODULES .. "lsp")

    -- Load COMPLETION module
    require(P_MODULES .. "completion")

    -- Load PRODUCTIVITY module
    require(P_MODULES .. "productivity")

    -- Automatic initial plugin installation
    if packer_bootstrap then
        packer.sync()
    end
end)
