local option = vim.opt

-- Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Auto-indent new lines
option.autoindent = true
-- Enable smart-indent
option.smartindent = true

-- Use spaces instead of tabs
option.expandtab = true
-- Number of auto-indent spaces
option.shiftwidth = 4
-- Number of spaces per Tab
option.softtabstop = 4
-- Number of columns per tab
option.tabstop = 4

-- Code wrapping
option.linebreak = true
option.breakindent = true

-- Show cursorline
option.cursorline = true

-- Always case-insensitive
option.ignorecase = true
-- Enable smart-case search
option.smartcase = true
-- Searches for strings incrementally
option.incsearch = true

-- Show line numbers
option.number = true
-- Enable relative line numbers
option.relativenumber = true

-- Show max. 10 completions
option.pumheight = 10
-- Max history of commands
option.history = 1000

-- Splits
option.splitright = true
option.splitbelow = true

-- Folding configuration
option.foldlevel = 99
option.foldlevelstart = 99
option.foldcolumn = "0"
option.foldenable = true
option.foldnestmax = 3
option.foldminlines = 1

-- Display eol characters
option.list = true
option.listchars:append({ tab = " ", lead = "·", trail = "·" })

-- Use en_us to spellcheck
option.spelllang = "en"

-- Global statusline
option.laststatus = 3

-- Command-line completion mode
option.wildmode = "longest:full,full"

-- Enable mouse for normal and visual modes
option.mouse = "nv"

-- sync with system clipboard register
option.clipboard = "unnamedplus"

-- Lines to scroll off screen
option.scrolljump = 5

-- Lead scroll by 8 lines
option.scrolloff = 8

-- No completion messages in secondary mode bar
option.shortmess = "ilmxoOsTIcF"

-- Disable secondary mode bar
option.showmode = false

-- Highlight matching
option.showmatch = true
option.matchtime = 3

-- No swap file
option.swapfile = false

-- Real-time substitute
option.inccommand = "split"

-- Completion options
option.completeopt = { "menu", "menuone", "noselect" }

-- Cmdline height
option.ch = 0

-- Lazyily redraw
option.lazyredraw = true
option.redrawtime = 10000

-- Max columns for syntax search
option.synmaxcol = 180

-- Undo dir (persistent undo's)
local undo_dir = vim.fn.expand("$HOME") .. [[/.cache/nvim/undo]]
if not vim.fn.isdirectory(undo_dir) then
	vim.fn.mkdir(undo_dir)
end
option.undodir = undo_dir
option.undofile = true

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
