local opt = vim.opt
local undo_dir = vim.fn.expand("$HOME") .. [[/.cache/nvim/undo]]

if not vim.fn.isdirectory(undo_dir) then vim.fn.mkdir(undo_dir) end

-- Leader Key
vim.g.mapleader = " "

-- Appearance
opt.breakindent = true -- Indent wrapped lines to match line start
opt.cmdheight = 0      -- Cmdline height
-- option.winblend = 8          -- Transparency
opt.winborder = "rounded" -- Float window border style
opt.pumborder = "rounded" -- Completion window border style
opt.pumblend = 10         -- Completion window transparency
opt.pumheight = 7         -- Maximum completion menu height
opt.pummaxwidth = 55      -- Maximum completion menu width
opt.fillchars:append({
  eob = " ",
  fold = " ",
  foldsep = " ",
  diff = "╱",
})

opt.laststatus = 3       -- Global statusline
opt.linebreak = true     -- Wrap long lines at 'breakat' (if 'wrap' is set)
opt.list = true          -- Show some helper symbols
opt.number = true        -- Show line numbers
opt.ruler = false        -- Don't show cursor position in command line
opt.signcolumn = "yes"   -- Always show sign column (otherwise it will shift text)
opt.stl = " "            -- Use custom statusline
opt.splitright = true    -- Vertical splits will be to the right
opt.termguicolors = true -- Enable gui colors
opt.wrap = false         -- Display long lines as just one line

opt.guicursor = {
  "i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100",
  "r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100",
} -- Blinking cursor

-- Backup
opt.backup = false                           -- Don't store backup while overwriting the file
opt.undodir = undo_dir                       -- Undo dir (persistent undo's)
opt.undofile = true                          -- Enable persistent undo (see also `:h undodir`)
opt.writebackup = false                      -- Don't store backup while overwriting the file
opt.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

-- Editing
vim.o.complete = ".,w,b,kspell"                     -- Use less sources
vim.o.completeopt = "menuone,noselect,fuzzy,nosort" -- Use custom behavior
vim.o.completetimeout = 100                         -- Limit sources delay
opt.ignorecase = true                               -- Ignore case when searching (use `\C` to force not doing that)
opt.incsearch = true                                -- Show search results while typing
opt.infercase = true                                -- Infer letter cases for a richer built-in keyword completion
opt.formatoptions = "rqnl1j"                        -- Don't autoformat comments
opt.smartcase = true                                -- Don't ignore case when searching if pattern has upper case
opt.virtualedit = "block"                           -- Allow going past the end of line in visual block mode

-- Tabs & Indent
opt.smartindent = true    -- Make indenting smart
opt.preserveindent = true -- Preserve indent structure as much as possible
opt.expandtab = true      -- Use spaces instead of tabs
opt.shiftround = true     -- Round indentation with `>`/`<` to shiftwidth
opt.shiftwidth = 4        -- Number of auto-indent spaces (0 follows tabstop value)
opt.softtabstop = 4       -- Number of spaces per Tab

-- Folding configuration
opt.foldcolumn = "0"
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldtext = [[v:lua.require('ui.foldtext').render()]]
opt.foldexpr = [[v:lua.require('utils').foldexpr()]]
opt.foldlevel = 10
opt.foldnestmax = 5
opt.foldminlines = 1
opt.foldopen:remove({ "search" })

-- Scrolling
opt.smoothscroll = true
opt.mousescroll = "ver:16,hor:4" -- Customize mouse scroll
opt.scrolljump = 5               -- Lines to scroll off screen
opt.scrolloff = 8                -- Lead scroll past bottom

-- System
-- opt.clipboard = "unnamedplus" -- Clipboard configuration
opt.mouse = "a" -- Enable mouse for all available modes
opt.grepformat = "%f:%l:%c:%m"

-- Timings
opt.swapfile = false -- No swap file
opt.redrawtime = 10000
opt.updatetime = 300 -- Autocmd update delay

-- Misc
opt.inccommand = "split"   -- Real-time substitute
opt.shortmess = "CFOSWaco" -- Remove intro screen & reduce command msgs
opt.showcmd = false        -- remove extra cmd display
opt.showmode = false       -- Don't show mode in command line
opt.splitkeep = "screen"   -- Reduce scrolling on splits
opt.synmaxcol = 200        -- Max columns for syntax search
opt.jumpoptions = "view"   -- make the jumplist behavior more intuitive

-- wether or not current enivronment supports nerd fonts
vim.g.use_nerdfonts = true

-- global language variables
vim.g.enabled_syntax_languages = {
  -- Configuration
  "json",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
  -- Data Science
  "julia",
  "matlab",
  "python",
  "r",
  -- Documentation
  "markdown",
  "markdown_inline",
  "typst",
  -- Systems
  "c",
  "cpp",
  "rust",
  "zig",
  -- Scripting
  "bash",
  "zsh",
  "lua",
  "regex",
  -- Source Control
  "diff",
  "gitcommit",
  "gitignore",
}

vim.g.md_filetypes = { "markdown", "norg", "org", "rmd", "quarto", "typst" }
