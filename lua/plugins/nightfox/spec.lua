local M = {}

local light_bg = "sel0"
local grey = "sel1"
local dark_bg = "bg1"
local status = { fg = "fg0", bg = "bg0" }

local accent = "syntax.conditional"

M.highlights = {

	-- core
	NormalFloat = { fg = "fg1", bg = "bg1" },
	StatusColumnBorder = { fg = "bg1" },

	-- statusline
	St_gitIcons = { fg = "syntax.string", bg = status.bg, style = "bold" },
	St_lspError = { fg = "diag.error", bg = status.bg },
	St_lspWarning = { fg = "diag.warn", bg = status.bg },
	St_LspHints = { fg = "diag.hint", bg = status.bg },
	St_LspInfo = { fg = "diag.info", bg = status.bg },
	St_LspStatus = { fg = "syntax.const", bg = status.bg, style = "italic" },
	St_LspProgress = { fg = "syntax.string", bg = status.bg },
	St_LspStatus_Icon = { fg = status.bg, bg = "syntax.const" },
	St_NormalMode = { fg = status.bg, bg = "syntax.const", style = "bold" },
	St_InsertMode = { fg = status.bg, bg = status.fg, style = "bold" },
	St_TerminalMode = { fg = status.bg, bg = "syntax.field", style = "bold" },
	St_NTerminalMode = { fg = status.bg, bg = "syntax.field", style = "bold" },
	St_VisualMode = { fg = status.bg, bg = "magenta", style = "bold" },
	St_ReplaceMode = { fg = status.bg, bg = "red", style = "bold" },
	St_ConfirmMode = { fg = status.bg, bg = "magenta", style = "bold" },
	St_CommandMode = { fg = status.bg, bg = "yellow", style = "bold" },
	St_SelectMode = { fg = status.bg, bg = "magenta", style = "bold" },
	St_NormalModeSep = { fg = "syntax.const", bg = grey },
	St_InsertModeSep = { fg = status.fg, bg = grey },
	St_TerminalModeSep = { fg = "syntax.field", bg = grey },
	St_NTerminalModeSep = { fg = "syntax.field", bg = grey },
	St_VisualModeSep = { fg = "magenta", bg = grey },
	St_ReplaceModeSep = { fg = "red", bg = grey },
	St_ConfirmModeSep = { fg = "magenta", bg = grey },
	St_CommandModeSep = { fg = "yellow", bg = grey },
	St_SelectModeSep = { fg = "magenta", bg = grey },
	St_EmptySpace = { fg = grey, bg = status.bg },
	St_cwd_icon = { fg = status.bg, bg = accent },
	St_cwd_text = { fg = accent, bg = light_bg },
	St_cwd_sep = { fg = accent, bg = status.bg },
	St_pos_sep = { fg = status.fg, bg = light_bg },
	St_pos_icon = { fg = status.bg, bg = status.fg },
	St_pos_text = { fg = status.fg, bg = light_bg },

	-- Telescope
	TelescopeBorder = { fg = dark_bg, bg = dark_bg },
	TelescopePromptBorder = { fg = light_bg, bg = light_bg },
	TelescopePromptNormal = { fg = "syntax.variable", bg = light_bg },
	TelescopePromptPrefix = { fg = grey, bg = light_bg },
	TelescopeNormal = { bg = dark_bg },
	TelescopePreviewTitle = { fg = dark_bg, bg = accent },
	TelescopePromptTitle = { fg = dark_bg, bg = accent },
	TelescopePromptCounter = { bg = light_bg },
	TelescopeResultsTitle = { fg = dark_bg, bg = accent },
	TelescopeMatching = { fg = "diag.error", bg = "NONE" },

	-- Completion
	CmpItemAbbrMatch = { fg = "syntax.func", bg = "NONE", style = "bold" },
	CmpItemAbbrMatchFuzzy = { fg = "syntax.func.dim", bg = "NONE", style = "bold" },
	CmpItemMenu = { fg = "syntax.func.dim", bg = "NONE", style = "italic" },
	CmpItemKindInterface = { fg = dark_bg, bg = "syntax.builtin1", style = "bold" },
	CmpItemKindColor = { fg = dark_bg, bg = "syntax.builtin1", style = "bold" },
	CmpItemKindTypeParameter = { fg = dark_bg, bg = "syntax.builtin1", style = "bold" },
	CmpItemKindText = { fg = dark_bg, bg = "syntax.string", style = "bold" },
	CmpItemKindEnum = { fg = dark_bg, bg = "syntax.builtin2", style = "bold" },
	CmpItemKindKeyword = { fg = dark_bg, bg = "syntax.keyword", style = "bold" },
	CmpItemKindConstant = { fg = dark_bg, bg = "syntax.const", style = "bold" },
	CmpItemKindConstructor = { fg = dark_bg, bg = "syntax.const", style = "bold" },
	CmpItemKindReference = { fg = dark_bg, bg = "syntax.const", style = "bold" },
	CmpItemKindFunction = { fg = dark_bg, bg = "syntax.func", style = "bold" },
	CmpItemKindStruct = { fg = dark_bg, bg = "syntax.ident", style = "bold" },
	CmpItemKindClass = { fg = dark_bg, bg = "syntax.ident", style = "bold" },
	CmpItemKindModule = { fg = dark_bg, bg = "syntax.preproc", style = "bold" },
	CmpItemKindOperator = { fg = dark_bg, bg = "syntax.operator", style = "bold" },
	CmpItemKindField = { fg = dark_bg, bg = "syntax.field", style = "bold" },
	CmpItemKindProperty = { fg = dark_bg, bg = "syntax.keyword", style = "bold" },
	CmpItemKindEvent = { fg = dark_bg, bg = "syntax.preproc", style = "bold" },
	CmpItemKindUnit = { fg = dark_bg, bg = "syntax.type", style = "bold" },
	CmpItemKindSnippet = { fg = dark_bg, bg = "syntax.type", style = "bold" },
	CmpItemKindFolder = { fg = dark_bg, bg = "syntax.conditional", style = "bold" },
	CmpItemKindVariable = { fg = dark_bg, bg = "syntax.variable", style = "bold" },
	CmpItemKindFile = { fg = dark_bg, bg = "syntax.regex", style = "bold" },
	CmpItemKindMethod = { fg = dark_bg, bg = "syntax.preproc", style = "bold" },
	CmpItemKindValue = { fg = dark_bg, bg = "syntax.number", style = "bold" },
	CmpItemKindEnumMember = { fg = dark_bg, bg = "syntax.keyword", style = "bold" },
}

return M
