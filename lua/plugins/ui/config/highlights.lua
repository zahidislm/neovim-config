local M = {}

local light_bg = "sel0"
local text_fg = "fg1"

local status = { fg = "bg0", bg = "bg1" }
local accent = "syntax.conditional"

M.base_hls = {
	NormalFloat = { fg = "fg1", bg = status.bg },
	StatusColumnBorder = { fg = status.bg },
}

M.heirline_hls = {
	HeirlineMagenta = { fg = "palette.magenta", bg = "palette.magenta" },
	HeirlineGreen = { fg = "palette.green", bg = "palette.green" },
	HeirlineOrange = { fg = "palette.orange", bg = "palette.orange" },
	HeirlineYellow = { fg = "palette.yellow", bg = "palette.yellow" },
	HeirlineRed = { fg = "palette.red", bg = "palette.red" },

	StatusLine = { bg = status.bg },
	HeirlineSlant = { fg = status.fg, bg = status.bg },
	HeirlineSlantInv = { fg = status.bg, bg = status.fg },
	HeirlineSlantError = { fg = "diag.error", bg = status.bg },
	HeirlineSlantWarn = { fg = "diag.warn", bg = status.bg },
	HeirlineSlantRuler = { fg = light_bg, bg = status.bg },
	HeirlineSlantInvMacro = { fg = "palette.blue", bg = status.fg },
	HeirlineGroup = { fg = text_fg, bg = status.fg },
	HeirlineGitAdded = { fg = "git.add", bg = status.fg },
	HeirlineGitChanged = { fg = "git.changed", bg = status.fg },
	HeirlineGitRemoved = { fg = "git.removed", bg = status.fg },
	HeirlineDiagError = { fg = status.bg, bg = "diag.error" },
	HeirlineDiagWarn = { fg = status.bg, bg = "diag.warn" },
	HeirlineDiagHint = { fg = "diag.hint", bg = status.bg },
	HeirlineDiagInfo = { fg = "diag.info", bg = status.bg },
	HeirlineRuler = { fg = text_fg, bg = light_bg },
	HeirlineMacro = { fg = status.fg, bg = "palette.blue" },
}

M.telescope_hls = {
	TelescopeBorder = { fg = status.bg, bg = status.bg },
	TelescopePromptBorder = { fg = light_bg, bg = light_bg },
	TelescopePromptNormal = { fg = "syntax.variable", bg = light_bg },
	TelescopePromptPrefix = { fg = light_bg, bg = light_bg },
	TelescopeNormal = { bg = status.bg },
	TelescopePreviewTitle = { fg = status.bg, bg = accent },
	TelescopePromptTitle = { fg = status.bg, bg = accent },
	TelescopePromptCounter = { bg = light_bg },
	TelescopeResultsTitle = { fg = status.bg, bg = accent },
	TelescopeMatching = { fg = "diag.error", bg = "NONE" },
}

M.lspkinds_hls = {
	mpItemAbbrMatch = { fg = "syntax.func", bg = "NONE", style = "bold" },
	CmpItemAbbrMatchFuzzy = { fg = "syntax.func.dim", bg = "NONE", style = "bold" },
	CmpItemMenu = { fg = "syntax.func.dim", bg = "NONE", style = "italic" },
	CmpItemKindInterface = { fg = status.bg, bg = "syntax.builtin1", style = "bold" },
	CmpItemKindColor = { fg = status.bg, bg = "syntax.builtin1", style = "bold" },
	CmpItemKindTypeParameter = { fg = status.bg, bg = "syntax.builtin1", style = "bold" },
	CmpItemKindText = { fg = status.bg, bg = "syntax.string", style = "bold" },
	CmpItemKindEnum = { fg = status.bg, bg = "syntax.builtin2", style = "bold" },
	CmpItemKindKeyword = { fg = status.bg, bg = "syntax.keyword", style = "bold" },
	CmpItemKindConstant = { fg = status.bg, bg = "syntax.const", style = "bold" },
	CmpItemKindConstructor = { fg = status.bg, bg = "syntax.const", style = "bold" },
	CmpItemKindReference = { fg = status.bg, bg = "syntax.const", style = "bold" },
	CmpItemKindFunction = { fg = status.bg, bg = "syntax.func", style = "bold" },
	CmpItemKindStruct = { fg = status.bg, bg = "syntax.ident", style = "bold" },
	CmpItemKindClass = { fg = status.bg, bg = "syntax.ident", style = "bold" },
	CmpItemKindModule = { fg = status.bg, bg = "syntax.preproc", style = "bold" },
	CmpItemKindOperator = { fg = status.bg, bg = "syntax.operator", style = "bold" },
	CmpItemKindField = { fg = status.bg, bg = "syntax.field", style = "bold" },
	CmpItemKindProperty = { fg = status.bg, bg = "syntax.keyword", style = "bold" },
	CmpItemKindEvent = { fg = status.bg, bg = "syntax.preproc", style = "bold" },
	CmpItemKindUnit = { fg = status.bg, bg = "syntax.type", style = "bold" },
	CmpItemKindSnippet = { fg = status.bg, bg = "syntax.type", style = "bold" },
	CmpItemKindFolder = { fg = status.bg, bg = "syntax.conditional", style = "bold" },
	CmpItemKindVariable = { fg = status.bg, bg = "syntax.variable", style = "bold" },
	CmpItemKindFile = { fg = status.bg, bg = "syntax.regex", style = "bold" },
	CmpItemKindMethod = { fg = status.bg, bg = "syntax.preproc", style = "bold" },
	CmpItemKindValue = { fg = status.bg, bg = "syntax.number", style = "bold" },
	CmpItemKindEnumMember = { fg = status.bg, bg = "syntax.keyword", style = "bold" },
}

function M.setup()
	local highlights = vim.tbl_extend("error", M.base_hls, M.heirline_hls, M.telescope_hls, M.lspkinds_hls)
	return highlights
end

return M
