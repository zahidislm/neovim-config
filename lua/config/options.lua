-- Additional options/keymaps/autocmds loaded by "mini.basics" plugin --
local option = vim.opt
local undo_dir = vim.fn.expand("$HOME") .. [[/.cache/nvim/undo]]

if not vim.fn.isdirectory(undo_dir) then
	vim.fn.mkdir(undo_dir)
end

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
option.foldopen:remove({ "search" })

-- Cursor configuration
option.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"

-- Global statusline
option.laststatus = 3

-- sync with system clipboard register
option.clipboard = "unnamedplus"

-- Lines to scroll off screen
option.scrolljump = 5

-- Lead scroll by 8 lines
option.scrolloff = 8

-- Remove intro screen
option.shortmess:append({ I = true })

-- remove extra cmd display
option.showcmd = false

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

-- Autocmd update delay
option.updatetime = 200

-- Max columns for syntax search
option.synmaxcol = 200

-- menu transparency
option.pumblend = 0
option.winblend = 0

-- Undo dir (persistent undo's)
option.undodir = undo_dir

-- disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python_host_skip_check = 1

-- set python path and shell
-- has significant performance impact due to shell cmd call to find python
-- defering this actually makes boot feel more responsive
vim.defer_fn(function()
	vim.g.python3_host_prog = require("utils").get_python()
end, 0)

-- remove ft maps
vim.g.no_plugin_maps = 1
