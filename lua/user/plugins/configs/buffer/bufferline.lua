require("bufferline").setup{
    options = {
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = true,
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
            },
        },
        separator_style = "slant",
        modified_icon = "",
		color_icons = true,
		show_buffer_icons = true,
        enforce_regular_tabs = true,
    },
}

-- Mappings
require(P_MAPPINGS .. "buffer.bufferline")
