local feedkey = function(key, mode)
    mode = mode or "n"
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require("cmp")

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('snippy').expand_snippet(args.body)
        end,
    },
    window = {
        documentation = {
            winhighlight = "NormalFloat:CmpDocumentation,FloatBorder:CmpDocumentationBorder",
        },
    },
    experimental = {
        ghost_text = true,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "snippy" },
        {
            name = "buffer",
            option = {
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        bufs[vim.api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                end,
            },
        },
        { name = "path"}
    })
})

local cmdline_formatting = {
    format = function(_, vim_item)
        vim_item.kind = ""
        vim_item.menu = ""
        return vim_item
    end,
}

local cmdline_mapping = cmp.mapping.preset.insert({
    ["<C-j>"] = cmp.mapping({
        c = function()
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            else
                feedkey("<Down>")
            end
        end,
    }),
    ["<C-k>"] = cmp.mapping({
        c = function()
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            else
                feedkey("<Up>")
            end
        end,
    }),
    ["<Tab>"] = cmp.mapping({
        c = function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            else
                fallback()
            end
        end,
    }),
})

cmp.setup.cmdline("/", {
    formatting = cmdline_formatting,
    mapping = cmdline_mapping,
    sources = cmp.config.sources({
        { name = "buffer" },
    }),
})

cmp.setup.cmdline(":", {
    formatting = cmdline_formatting,
    mapping = cmdline_mapping,
    sources = cmp.config.sources({
        { name = "cmdline" },
        { name = "buffer" },
        { name = "path" },
    }),
})

-- Add nvim-autopairs support
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
