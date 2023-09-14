local option = vim.opt
local undo_dir = vim.fn.expand("$HOME") .. [[/.cache/nvim/undo]]

if not vim.fn.isdirectory(undo_dir) then
	vim.fn.mkdir(undo_dir)
end

-- Leader Key
vim.g.mapleader = " "

-- Appearance
option.breakindent = true -- Indent wrapped lines to match line start
option.cmdheight = 0 -- Cmdline height
option.cursorline = true -- Highlight current line
option.fillchars = { eob = " " } -- Don't show `~` outside of buffer
option.laststatus = 3 -- Global statusline
option.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
option.list = true -- Show some helper symbols
option.number = true -- Show line numbers
option.ruler = false -- Don't show cursor position in command line
option.signcolumn = "yes" -- Always show sign column (otherwise it will shift text)
option.splitbelow = true -- Horizontal splits will be below
option.splitright = true -- Vertical splits will be to the right
option.termguicolors = true -- Enable gui colors
option.wrap = false -- Display long lines as just one line

-- Blinking Cursor configuration
option.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-iCursor,r-cr:hor20,o:hor50,\z
    a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,\z
    sm:block-blinkwait175-blinkoff150-blinkon175"

-- Backup
option.backup = false -- Don't store backup while overwriting the file
option.undodir = undo_dir -- Undo dir (persistent undo's)
option.undofile = true -- Enable persistent undo (see also `:h undodir`)
option.writebackup = false -- Don't store backup while overwriting the file

-- Editing
option.completeopt = { "menuone", "noinsert", "noselect" } -- Customize completions
option.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
option.incsearch = true -- Show search results while typing
option.infercase = true -- Infer letter cases for a richer built-in keyword completion
option.formatoptions = "qjl1" -- Don't autoformat comments
option.smartcase = true -- Don't ignore case when searching if pattern has upper case
option.virtualedit = "block" -- Allow going past the end of line in visual block mode

-- Tabs & Indent
option.smartindent = true -- Make indenting smart
option.preserveindent = true -- Preserve indent structure as much as possible
option.expandtab = true -- Use spaces instead of tabs
option.shiftwidth = 4 -- Number of auto-indent spaces
option.softtabstop = 4 -- Number of spaces per Tab
option.tabstop = 4 -- Number of columns per tab

-- Folding configuration
option.foldcolumn = "0"
option.foldenable = true
option.foldlevel = 99
option.foldlevelstart = 99
option.foldnestmax = 3
option.foldminlines = 1
option.foldopen:remove({ "search" })

-- Scrolling
option.scrolljump = 5 -- Lines to scroll off screen
option.scrolloff = 8 -- Lead scroll past bottom

-- System
option.clipboard = "unnamedplus" -- Cursor configuration
option.mouse = "a" -- Enable mouse for all available modes
option.swapfile = false -- No swap file

-- Timings
option.lazyredraw = true
option.redrawtime = 5000
option.updatetime = 200 -- Autocmd update delay

-- Misc
option.inccommand = "split" -- Real-time substitute
option.shortmess:append("WcCI") -- Remove intro screen & reduce command msgs
option.showcmd = false -- remove extra cmd display
option.splitkeep = "screen" -- Reduce scrolling on splits
option.synmaxcol = 200 -- Max columns for syntax search
vim.cmd("filetype plugin indent on") -- Enable all filetype plugins

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
