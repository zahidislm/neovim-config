local icons = vim.g.ui_icons
local cmp = require("cmp")
local snippy = require("snippy")

local function highlight_border(hl_name)
	hl_name = type(hl_name) == "string" and hl_name or "CmpBorder"
	local border = icons.misc.border
	local border_with_hls = {}

	for char = 1, #border do
		border_with_hls[char] = { border[char], hl_name }
	end

	return border_with_hls
end

return {
	experimental = { ghost_text = { hl_group = "LspCodeLens" } },
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			local kind = require("lspkind").cmp_format({
				mode = "symbol_text",
				maxwidth = 50,
				symbol_map = icons.symbol_map,
				ellipsis_char = "...",
			})(entry, vim_item)
			local strings = vim.split(kind.kind, "%s", { trimempty = true })
			kind.kind = " " .. strings[1] .. " "
			kind.menu = "    " .. strings[2] .. ""

			return vim_item
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),

		["<Tab>"] = cmp.mapping(function(fallback)
			local has_words_before = function()
				local ignore_chars = { [["]], [[']] }
				local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
				local parsed_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
				local prev_char = parsed_line:sub(col, col)
				local next_char = parsed_line:sub(col + 1, col + 1)
				local has_ignore_char = vim.tbl_contains(ignore_chars, prev_char)
					or vim.tbl_contains(ignore_chars, next_char)
				local match = prev_char:match("%s")

				return col ~= 0 and match == nil and not has_ignore_char
			end

			if cmp.visible() then
				cmp.select_next_item()
			elseif snippy.can_expand_or_advance() then
				snippy.expand_or_advance()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif snippy.can_jump(-1) then
				snippy.previous()
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	preselect = cmp.PreselectMode.None,
	snippet = {
		expand = function(args)
			snippy.expand_snippet(args.body)
		end,
	},
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			function(entry1, entry2)
				local _, entry1_under = entry1.completion_item.label:find("^_+")
				local _, entry2_under = entry2.completion_item.label:find("^_+")
				entry1_under = entry1_under or 0
				entry2_under = entry2_under or 0
				if entry1_under > entry2_under then
					return false
				elseif entry1_under < entry2_under then
					return true
				end
			end,

			cmp.config.compare.kind,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
	sources = {
		{ name = "nvim_lsp", priority = 1000 },
		{ name = "nvim_lsp_signature_help", priority = 900 },
		{ name = "snippy", priority = 750 },
		{ name = "buffer", keyword_length = 5, priority = 500 },
		{ name = "async_path", priority = 250 },
	},
	window = {
		completion = {
			winhighlight = "Normal:NormalFloat,Search:None",
			border = highlight_border(),
			col_offset = -4,
			side_padding = 0,
			scrollbar = false,
		},
		documentation = {
			winhighlight = "Normal:NormalFloat,Search:None",
			border = highlight_border(),
			max_height = 15,
			max_width = 60,
		},
	},
}
