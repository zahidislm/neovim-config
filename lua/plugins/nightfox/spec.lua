local M = {}

local light_bg = "sel0"
local grey = "sel1"
local dark_bg = "bg1"
local status = { fg = "fg0", bg = "bg0" }

local accent = "syntax.conditional"

M.highlights = {

	-- core
	NormalFloat = { fg = "fg1", bg = "bg1" },

	-- statusline
	St_gitIcons = { fg = "fg3", bg = status.bg, fmt = "bold" },
	St_lspError = { fg = "diag.error", bg = status.bg },
	St_lspWarning = { fg = "diag.warn", bg = status.bg },
	St_LspHints = { fg = "diag.hint", bg = status.bg },
	St_LspInfo = { fg = "diag.info", bg = status.bg },
	St_LspStatus = { fg = "syntax.const", bg = status.bg },
	St_LspProgress = { fg = "syntax.string", bg = status.bg },
	St_LspStatus_Icon = { fg = status.bg, bg = "syntax.const" },
	St_NormalMode = { fg = status.bg, bg = "cyan", fmt = "bold" },
	St_InsertMode = { fg = status.bg, bg = status.fg, fmt = "bold" },
	St_TerminalMode = { fg = status.bg, bg = "syntax.field", fmt = "bold" },
	St_NTerminalMode = { fg = status.bg, bg = "syntax.field", fmt = "bold" },
	St_VisualMode = { fg = status.bg, bg = "magenta", fmt = "bold" },
	St_ReplaceMode = { fg = status.bg, bg = "red", fmt = "bold" },
	St_ConfirmMode = { fg = status.bg, bg = "magenta", fmt = "bold" },
	St_CommandMode = { fg = status.bg, bg = "yellow", fmt = "bold" },
	St_SelectMode = { fg = status.bg, bg = "magenta", fmt = "bold" },
	St_NormalModeSep = { fg = "cyan", bg = grey },
	St_InsertModeSep = { fg = status.fg, bg = grey },
	St_TerminalModeSep = { fg = "syntax.field", bg = grey },
	St_NTerminalModeSep = { fg = "syntax.field", bg = grey },
	St_VisualModeSep = { fg = "magenta", bg = grey },
	St_ReplaceModeSep = { fg = "red", bg = grey },
	St_ConfirmModeSep = { fg = "magenta", bg = grey },
	St_CommandModeSep = { fg = "yellow", bg = grey },
	St_SelectModeSep = { fg = "magenta", bg = grey },
	St_EmptySpace = { fg = grey, bg = light_bg },
	St_EmptySpace2 = { fg = grey, bg = status.bg },
	St_file_info = { fg = "white", bg = light_bg },
	St_file_sep = { fg = light_bg, bg = status.bg },
	St_cwd_icon = { fg = status.bg, bg = accent },
	St_cwd_text = { fg = accent, bg = light_bg },
	St_cwd_sep = { fg = accent, bg = status.bg },
	St_pos_sep = { fg = "syntax.string", bg = light_bg },
	St_pos_icon = { fg = status.bg, bg = "syntax.string" },
	St_pos_text = { fg = "syntax.string", bg = light_bg },

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

return M
