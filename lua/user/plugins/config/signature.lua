require("lsp_signature").setup({
    bind = true,
    hint_enable = false,
    hint_prefix = "",
    floating_window = true,
    hi_parameter = "ThemerHeadingH1",
    extra_trigger_chars = { "(", "," },
    handler_opts = {
        border = "single",
    },
})
