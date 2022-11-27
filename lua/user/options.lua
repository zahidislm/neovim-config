local option = vim.opt

-- File encoding
option.fileencoding = "utf-8"

-- LINUX fileformat
option.fileformat = "unix"
option.fileformats = "unix"

-- Enable dark background colorschemes
option.background = "dark"
-- Enable 24bit colors in terminal
option.termguicolors = true

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

-- No wrap
option.wrap = false

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
option.foldmethod = "expr"
option.foldexpr = "nvim_treesitter#foldexpr()"
option.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend))]]
option.foldnestmax = 3
option.foldminlines = 1

-- Display eol characters
option.list = true

-- Display chars
option.fillchars = {
    eob = "–",
    fold = " ",
    foldsep = " ",
    foldclose = "",
    foldopen = "",
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┫",
    vertright = "┣",
    verthoriz = "╋",
}
option.listchars:append({ tab = " ", lead = "·", trail = "·", eol = "﬋" })

-- Use en_us to spellcheck
option.spelllang = "en_us"

-- Global statusline
option.laststatus = 3

-- No redraw during macro, regex execution
option.lazyredraw = true

-- Enable mouse for normal and visual modes
option.mouse = "nv"

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

-- Cmdline height
option.ch = 0

-- Lazyily redraw
option.lazyredraw = true
option.redrawtime = 10000

-- Max columns for syntax search
option.synmaxcol = 180

-- Undo dir (persistent undo's)
local undo_dir = HOME_PATH .. [[/.cache/nvim/undo]]
if not vim.fn.isdirectory(undo_dir) then
    vim.fn.mkdir(undo_dir)
end
option.undodir = undo_dir
option.undofile = true

-- Python3 path
vim.g.python3_host_prog = vim.fn.split(vim.fn.trim(vim.fn.system("where python")), "\n")[1]

-- Disable builtin vim plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "matchit",
    "man",
    "shada",
    "spellfile",
    "remote",
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

-- Disable perl provider
vim.g.loaded_perl_provider = 0

-- Disable ruby provider
vim.g.loaded_ruby_provider = 0

-- Disable node provider
vim.g.loaded_node_provider = 0

-- Clipboard
option.clipboard = "unnamedplus"
vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
        ["+"] = "win32yank.exe -i --crlf",
        ["*"] = "win32yank.exe -i --crlf"
    },
    paste = {
        ["+"] = "win32yank.exe -o --crlf",
        ["*"] = "win32yank.exe -o --crlf"
    },
    cache_enable = 0,
}
