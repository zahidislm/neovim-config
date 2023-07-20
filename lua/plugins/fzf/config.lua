local icons = vim.g.ui_icons
local picker_height = 0.667
local ignore_patterns = {
	-- editor
	".vscode\\",

	-- git
	".git\\",
	".github\\",

	-- python
	"__pycache__\\",
	".*%.py[cod]",
	".*$py%.class",
	"%.Python",
	"build\\",
	"develop-eggs\\",
	"dist\\",
	"downloads\\",
	"eggs\\",
	"%.eggs\\",
	"lib\\",
	"lib64\\",
	"parts\\",
	"sdist\\",
	"var\\",
	"wheels\\",
	"share\\python-wheels\\",
	".*%.egg-info\\",
	"%.installed%.cfg",
	".*%.egg",
	"MANIFEST",
	"%.env",
	"%.venv",
	"env\\",
	"venv\\",
	"ENV\\",
	"env%.bak\\",
	"venv%.bak\\",

	-- images
	"%.jpg",
	"%.jpeg",
	"%.jpe",
	"%.jif",
	"%.jfif",
	"%.jfi",
	"%.jp2",
	"%.j2k",
	"%.jpf",
	"%.jpx",
	"%.jpm",
	"%.mj2",
	"%.jxr",
	"%.hdp",
	"%.wdp",
	"%.gif",
	"%.raw",
	"%.webp",
	"%.png",
	"%.apng",
	"%.mng",
	"%.tiff",
	"%.tif",
	"%.svg",
	"%.svgz",
	"%.pdf",
	"%.xbm",
	"%.bmp",
	"%.dib",
	"%.ico",
	"%.3dm",
	"%.max",

	-- fonts
	"%.fnt",
	"%.fon",
	"%.otf",
	"%.ttf",
	"%.woff",
	"%.woff2",

	-- npm
	"node_modules\\",
}

return {
	"telescope",
	winopts = {
		border = { " ", " ", " ", " ", " ", " ", " ", " " },
		row = 1,
		width = 1.0,
		height = 0.3,
		preview = {
			default = "bat_native",
			title_align = "center",
			delay = 70,
		},
		hl = {
			scrollfloat_e = "",
			scrollfloat_f = "PmenuSel",
		},
	},
	fzf_opts = {
		["--no-info"] = "",
		["--info"] = "hidden",
		["--padding"] = "5%,2.5%,5%,2.5%",
		["--header"] = " ",
		["--no-scrollbar"] = "",
		["--prompt"] = icons.misc.select,
		["--pointer"] = icons.misc.select,
	},
	fzf_colors = {
		["fg"] = { "fg", "Comment" },
		["bg"] = { "bg", "Normal" },
		["preview-bg"] = { "bg", "FzfLuaPreviewNormal" },
		["hl"] = { "fg", "FzfLuaHighlight" },
		["fg+"] = { "fg", "NormalFloat" },
		["bg+"] = { "bg", "FzfLuaPreviewNormal" },
		["hl+"] = { "fg", "FzfLuaHighlightPlus" },
		["info"] = { "fg", "FzfLuaInfo" },
		["border"] = { "fg", "FzfLuaPreviewNormal" },
		["prompt"] = { "fg", "FzfLuaPrompt" },
		["pointer"] = { "fg", "FzfLuaPrompt" },
		["marker"] = { "fg", "FzfLuaMarker" },
		["spinner"] = { "fg", "FzfLuaSpinner" },
		["header"] = { "fg", "FzfLuaHeader" },
		["gutter"] = { "bg", "StatusLine" },
	},
	previewers = { git_diff = { pager = "delta --width=$FZF_PREVIEW_COLUMNS" } },
	file_icon_padding = " ",
	file_ignore_patterns = ignore_patterns,

	-- Providers
	buffers = {
		no_header = true,
		fzf_opts = { ["--delimiter"] = ":", ["--with-nth"] = "..-2" },
	},
	files = {
		git_icons = false,
		winopts = { height = picker_height },
	},
	git = {
		status = {
			preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
			file_icons = false,
			no_header = true,
			winopts = { height = picker_height },
		},
		commits = {
			preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
			no_header = true,
			winopts = {
				preview = {
					layout = "vertical",
					vertical = "right:50%",
					wrap = "wrap",
				},
			},
		},
		bcommits = {
			preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
			no_header = true,
			winopts = {
				preview = {
					layout = "vertical",
					vertical = "right:50%",
					wrap = "wrap",
				},
			},
		},
		branches = {
			cmd = "git branch --all --color",
			winopts = {
				preview = {
					layout = "vertical",
					vertical = "right:50%",
					wrap = "wrap",
				},
			},
		},
		icons = {
			["A"] = { icon = icons.git.added, color = "green" },
			["D"] = { icon = icons.git.deleted, color = "red" },
			["M"] = { icon = icons.git.modified, color = "yellow" },
			["?"] = { icon = icons.git.untracked, color = "magenta" },
			["R"] = { icon = icons.git.renamed, color = "yellow" },
		},
	},
	grep = {
		git_icons = false,
		winopts = { height = picker_height },
	},
	oldfiles = {
		prompt = "Recent Files> ",
		winopts = {
			height = 0.33,
			width = picker_height,
			row = 0.45,
			preview = { hidden = "hidden" },
		},
	},
	quickfix = { winopts = { height = picker_height } },
}
