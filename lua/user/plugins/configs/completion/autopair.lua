local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

require("nvim-autopairs").setup({
    enable_check_bracket_line = false,
    ignored_next_char = "[%w%.]",
    fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
    },
})

-- Add nvim-autopairs support to completions
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
