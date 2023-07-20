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

M.fzf_hls = {
	FzfLuaBorder = { fg = status.bg, bg = status.bg },
	FzfLuaPreviewNormal = { fg = light_bg, bg = light_bg },
	FzfLuaSearch = { fg = "syntax.variable", bg = light_bg },
	FzfLuaTitle = { fg = status.bg, bg = accent },
	FzfLuaCursorLine = { bg = "bg0" },

	-- FZF terminal colors
	FzfLuaHighlight = { fg = "palette.blue" },
	FzfLuaHighlightPlus = { fg = "syntax.builtin1" },
	FzfLuaInfo = { fg = "palette.green" },
	FzfLuaPrompt = { fg = "palette.magenta" },
	FzfLuaMarker = { fg = "palette.red" },
	FzfLuaSpinner = { fg = "syntax.builtin3" },
	FzfLuaHeader = { fg = "syntax.conditional" },
}

M.mini_files_hls = {
	MiniFilesBorder = { link = "FzfLuaBorder" },
	MiniFilesNormal = { link = "Normal" },
	MiniFilesTitle = { link = "FzfLuaTitle" },
	MiniFilesTitleFocused = { link = "FzfLuaTitle" },
}

M.lspkinds_hls = {
	CmpBorder = { fg = light_bg },
	CmpItemKindInterface = { fg = status.bg, bg = "syntax.builtin1" },
	CmpItemKindColor = { fg = status.bg, bg = "syntax.builtin1" },
	CmpItemKindTypeParameter = { fg = status.bg, bg = "syntax.builtin1" },
	CmpItemKindText = { fg = status.bg, bg = "syntax.string" },
	CmpItemKindEnum = { fg = status.bg, bg = "syntax.builtin2" },
	CmpItemKindKeyword = { fg = status.bg, bg = "syntax.keyword" },
	CmpItemKindConstant = { fg = status.bg, bg = "syntax.const" },
	CmpItemKindConstructor = { fg = status.bg, bg = "syntax.const" },
	CmpItemKindReference = { fg = status.bg, bg = "syntax.const" },
	CmpItemKindFunction = { fg = status.bg, bg = "syntax.func" },
	CmpItemKindStruct = { fg = status.bg, bg = "syntax.ident" },
	CmpItemKindClass = { fg = status.bg, bg = "syntax.ident" },
	CmpItemKindModule = { fg = status.bg, bg = "syntax.preproc" },
	CmpItemKindOperator = { fg = status.bg, bg = "syntax.operator" },
	CmpItemKindField = { fg = status.bg, bg = "syntax.field" },
	CmpItemKindProperty = { fg = status.bg, bg = "syntax.keyword" },
	CmpItemKindEvent = { fg = status.bg, bg = "syntax.preproc" },
	CmpItemKindUnit = { fg = status.bg, bg = "syntax.type" },
	CmpItemKindSnippet = { fg = status.bg, bg = "syntax.type" },
	CmpItemKindFolder = { fg = status.bg, bg = "syntax.conditional" },
	CmpItemKindVariable = { fg = status.bg, bg = "syntax.variable" },
	CmpItemKindFile = { fg = status.bg, bg = "syntax.regex" },
	CmpItemKindMethod = { fg = status.bg, bg = "syntax.preproc" },
	CmpItemKindValue = { fg = status.bg, bg = "syntax.number" },
	CmpItemKindEnumMember = { fg = status.bg, bg = "syntax.keyword" },
}

function M.setup()
	local highlights = vim.tbl_extend("error", M.base_hls, M.heirline_hls, M.fzf_hls, M.mini_files_hls, M.lspkinds_hls)
	return highlights
end

return M
