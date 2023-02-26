-- Additional options/keymaps/autocmds loaded by "mini.basics" plugin --
local option = vim.opt

-- Leader Key
vim.g.mapleader = " "

-- Use spaces instead of tabs
option.expandtab = true
-- Number of auto-indent spaces
option.shiftwidth = 4
-- Number of spaces per Tab
option.softtabstop = 4
-- Number of columns per tab
option.tabstop = 4

-- Folding configuration
option.foldlevel = 99
option.foldlevelstart = 99
option.foldcolumn = "0"
option.foldenable = true
option.foldnestmax = 3
option.foldminlines = 1

-- Display eol characters
option.listchars:append({ tab = " ", lead = "·", trail = "·" })

-- pop-up menu transparency
option.pumblend = 0

-- Global statusline
option.laststatus = 3

-- sync with system clipboard register
option.clipboard = "unnamedplus"

-- Lines to scroll off screen
option.scrolljump = 5

-- Lead scroll by 8 lines
option.scrolloff = 8

-- No completion messages in secondary mode bar
option.shortmess = "ilmxoOsTIcF"

-- Highlight matching
option.showmatch = true
option.matchtime = 3

-- No swap file
option.swapfile = false

-- Real-time substitute
option.inccommand = "split"

-- Cmdline height
option.cmdheight = 0

-- Lazyily redraw
option.lazyredraw = true
option.redrawtime = 5000

-- Max columns for syntax search
option.synmaxcol = 200

-- Undo dir (persistent undo's)
local undo_dir = vim.fn.expand("$HOME") .. [[/.cache/nvim/undo]]
if not vim.fn.isdirectory(undo_dir) then
	vim.fn.mkdir(undo_dir)
end
option.undodir = undo_dir

-- Disable builtin vim plugins
local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
	"tutor",
	"rplugin",
	"syntax",
	"synmenu",
	"optwin",
	"compiler",
	"bugreport",
	"ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end
