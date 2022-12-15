local scheme = "carbonfox"

local light_bg = "sel0"
local dark_bg = "bg1"
local accent = "syntax.conditional"

local groups = {
	-- Telescope
	TelescopeBorder = { fg = dark_bg, bg = dark_bg },
	TelescopePromptBorder = { fg = light_bg, bg = light_bg },
	TelescopePromptNormal = { fg = "syntax.variable", bg = light_bg },
	TelescopePromptPrefix = { fg = "fg2", bg = light_bg },
	TelescopeNormal = { bg = dark_bg },
	TelescopePreviewTitle = { fg = dark_bg, bg = accent },
	TelescopePromptTitle = { fg = dark_bg, bg = accent },
	TelescopePromptCounter = { bg = light_bg },
	TelescopeResultsTitle = { fg = dark_bg, bg = accent },
	TelescopeMatching = { fg = "diag.error", bg = "NONE" },
	-- Completion
	CmpItemAbbrMatch = { fg = "syntax.func", bg = "NONE", fmt = "bold" },
	CmpItemAbbrMatchFuzzy = { fg = "syntax.func.dim", bg = "NONE", fmt = "bold" },
	CmpItemMenu = { fg = "syntax.func.dim", bg = "NONE", fmt = "italic" },
	CmpItemKindInterface = { fg = dark_bg, bg = "syntax.builtin1", fmt = "bold" },
	CmpItemKindColor = { fg = dark_bg, bg = "syntax.builtin1", fmt = "bold" },
	CmpItemKindTypeParameter = { fg = dark_bg, bg = "syntax.builtin1", fmt = "bold" },
	CmpItemKindText = { fg = dark_bg, bg = "syntax.string", fmt = "bold" },
	CmpItemKindEnum = { fg = dark_bg, bg = "syntax.builtin2", fmt = "bold" },
	CmpItemKindKeyword = { fg = dark_bg, bg = "syntax.keyword", fmt = "bold" },
	CmpItemKindConstant = { fg = dark_bg, bg = "syntax.const", fmt = "bold" },
	CmpItemKindConstructor = { fg = dark_bg, bg = "syntax.const", fmt = "bold" },
	CmpItemKindReference = { fg = dark_bg, bg = "syntax.const", fmt = "bold" },
	CmpItemKindFunction = { fg = dark_bg, bg = "syntax.func", fmt = "bold" },
	CmpItemKindStruct = { fg = dark_bg, bg = "syntax.ident", fmt = "bold" },
	CmpItemKindClass = { fg = dark_bg, bg = "syntax.ident", fmt = "bold" },
	CmpItemKindModule = { fg = dark_bg, bg = "syntax.preproc", fmt = "bold" },
	CmpItemKindOperator = { fg = dark_bg, bg = "syntax.operator", fmt = "bold" },
	CmpItemKindField = { fg = dark_bg, bg = "syntax.field", fmt = "bold" },
	CmpItemKindProperty = { fg = dark_bg, bg = "syntax.keyword", fmt = "bold" },
	CmpItemKindEvent = { fg = dark_bg, bg = "syntax.preproc", fmt = "bold" },
	CmpItemKindUnit = { fg = dark_bg, bg = "syntax.type", fmt = "bold" },
	CmpItemKindSnippet = { fg = dark_bg, bg = "syntax.type", fmt = "bold" },
	CmpItemKindFolder = { fg = dark_bg, bg = "syntax.conditional", fmt = "bold" },
	CmpItemKindVariable = { fg = dark_bg, bg = "syntax.variable", fmt = "bold" },
	CmpItemKindFile = { fg = dark_bg, bg = "syntax.regex", fmt = "bold" },
	CmpItemKindMethod = { fg = dark_bg, bg = "syntax.preproc", fmt = "bold" },
	CmpItemKindValue = { fg = dark_bg, bg = "syntax.number", fmt = "bold" },
	CmpItemKindEnumMember = { fg = dark_bg, bg = "syntax.keyword", fmt = "bold" },
}

require("nightfox").setup({
	options = {
		dim_inactive = true,
	},

	groups = { all = groups },
})

vim.cmd("colorscheme " .. scheme)
