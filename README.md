<div align="center">

# ⏣ neovim-config

![Screenshot of neovim configuration in both light & dark mode](https://i.8upload.com/image/90e83324810d6f10/banner.png)

**This configuration builds Neovim from scratch. It uses `vim.pack`, native LSP, and a UI layer written by hand.**

![Neovim](https://img.shields.io/badge/Neovim-%E2%89%A50.12-57A143?style=flat-square&logo=neovim&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-000000?style=flat-square&logo=apple&logoColor=F0F0F0)
![License](https://img.shields.io/badge/license-Apache--2.0-blue?style=flat-square)
![Colorscheme](https://img.shields.io/badge/colorscheme-Kans%C5%8D-8a7a99?style=flat-square)

</div>

<br>

## Philosophy

For me, Neovim is a text editor first, a code editor second, and a diff viewer third.

I designed my configuration and workflow around this idea.
This configuration does not try to do everything. It does not replace a terminal, a multiplexer, or an IDE. It only tries to make text editing in Neovim more enjoyable and convenient, at least for me.

Use a terminal to manage files and directories. Use a multiplexer for complex splits. Use an IDE to debug code. Use Neovim to edit text.

> [!NOTE]
> This is a personal configuration. I tuned it for one person's workflow on purpose. It is not a distribution. It does not try to be easy for beginners. I built many parts of it to learn how a particular Neovim internal function worked, not because no plugin already did the job. Feel free to read, copy, or fork pieces of it. But think twice before you point `git clone` straight at `~/.config/nvim` and hope for the best.

This configuration does not use `lazy.nvim`, `telescope.nvim`, `mason.nvim`, `blink.cmp`, or `lualine.nvim`. This is not a marketing point. It is simply what remained once I started replacing these tools with Neovim's native equivalents, and never really stopped. `vim.pack` handles plugin management. `mini.completion` runs completion against native LSP, and the snippets use about thirty lines of Lua. I wrote the statusline, statuscolumn, quickfix formatting, hover floats, and winbar breadcrumbs by hand. These files live under `lua/ui/`, backed by a small set of shared helpers under `lua/utils/` (color math, floating-window placement, fold rendering, file operations). `mini.nvim` does the rest of the work, in place of a dozen small plugins.

---

### Contents

- [The UI](#the-ui)
  - [statuscolumn](#statuscolumnlua)
  - [hovers](#hovers-collection-of-custom-float-ui)
  - [breadcrumbs](#breadcrumbslua-symbols-winbar)
  - [foldtext](#foldtextlua-folds-that-keep-their-syntax-highlighting)
  - [quickfix](#quickfixlua-a-custom-quickfixtextfunc-handler)
  - [statusline](#statusline-an-event-driven-statusline)
  - [theming](#icons-coloring-and-the-highlight-overrides)
- [Plugins](#the-plugins)
  - [vim.pack wrapper](#packadd-the-vimpack-wrapper)
- [LSP](#native-lsp)
- [Snippets](#snippets-without-a-snippet-plugin)
- [Colorscheme](#colorscheme)
- [Requirements & installation](#requirements--installation)
- [Credit where it's due](#credit-where-its-due)

---

## The UI

None of this exists because the equivalent plugins are bad. `lualine.nvim`, `noice.nvim`, and similar plugins all work well. I wrote my own versions mostly as an excuse to actually read the parts of `:help api` I would otherwise have skipped. A few of them fit how I work better, so they stuck around.

### `statuscolumn.lua`

I forked this from [folke/snacks.nvim](https://github.com/folke/snacks.nvim)'s statuscolumn implementation. Then I trimmed it down strictly to marks, signs, git signs, and folds.

### `hovers`: Collection of custom float UI
`hovers/diagnostics.lua` replaces `vim.diagnostic.open_float()`. `hovers/lsp.lua` replaces `vim.lsp.buf.hover()`, bound to `K`. Both are thin skins over the same placement math, which lives in `lua/utils/hoverpos.lua` so it is not duplicated across two nearly identical floating windows.
 
`hovers/diagnostics`: formats the diagnostic float with a custom style, to show different diagnostic types. It also lets you jump to each diagnostic on the line. 

<details>
<summary><b>Expand to see details.</b></summary>
<br>
<picture><img src="https://i.8upload.com/image/df5cbae0ddcdf2d0/screenshot-hover-diag.png" alt="diag-hover screenshot" /></picture>
</details>

`hovers/lsp`: Shows documentation for the word under the cursor, and formats it in a custom style.

<details>
<summary><b>Expand to see details.</b></summary>
<br>
<picture><img src="https://i.8upload.com/image/a7724d384c20f14c/screenshot-hover-lsp.png" alt="lsp-hover screenshot" /></picture>

This module classifies the item under the cursor into a kind, such as a function, class, or variable, using Tree-sitter and semantic-token captures. It tints the border and title badge to match this kind. It also re-wraps the returned markdown to a sane width, instead of trusting whatever width the language server sent.
</details>

### `breadcrumbs.lua`: Symbols winbar

A winbar component that shows the current symbol.

<details>
<summary><b>Expand to see details.</b></summary>
<br>

<picture><img src="https://i.8upload.com/image/4861067022e098f4/screenshot-breadcrumbs.png" alt="breadcrumbs screenshot" /></picture>

If an attached LSP client supports `textDocument/documentSymbol`, this module walks the returned symbol tree to find the symbol path that contains the cursor. If no client is attached, it walks up the Tree-sitter parent chain instead. It matches node types across roughly ten grammars onto a shared set of icon categories. For anonymous nodes, such as a JS arrow function or a Lua `M.foo = function()`, it recovers the name by looking one level up, at the enclosing declaration.
</details>

### `foldtext.lua`: Folds that keep their syntax highlighting

A custom foldtext implementation, with careful attention to appearance.

<details>
<summary><b>Expand to see details.</b></summary>
<br>

<picture><img src="https://i.8upload.com/image/6eed6e8054d6f3a2/screenshot-foldtext.png" alt="foldtext screenshot" /></picture>

Neovim's default foldtext shows only the bare first line. This module runs the buffer's actual Tree-sitter `highlights` query against the fold's start and end lines. It resolves overlapping capture ranges and reassembles the line as a list of `{text, highlight}` chunks. As a result, a folded function signature still shows types and keywords in their normal colors.
</details>

### `quickfix.lua`: A custom `quickfixtextfunc` handler

Custom style and layout for quickfix items.

<details>
<summary><b>Expand to see details.</b></summary>
<br>

<picture><img src="https://i.8upload.com/image/f3b79e67153ac072/screenshot-quickfix.png" alt="quickfix screenshot" /></picture>

Each line gets a diagnostic-severity icon, a `mini.icons` filetype icon, and a path. Every interior segment of the path is abbreviated down to one or two characters. The three columns line up and align, separated by `│`. This character also serves as the delimiter that `nvim-bqf` expects for its fzf preview filter. This module prefers showing the *live* buffer line over the stored item text. As a result, a long-running quickfix session still reflects the edits you have made since you built the list.
</details>

### `statusline`: An event-driven statusline

The design aims for high efficiency in both performance and memory use:
- Each component declares the exact autocmd events it needs. `render.lua` re-evaluates only the components subscribed to that specific event.
- Before writing, the module compares each component's rendered output against a cached string. If nothing changed, `redrawstatus` never fires.
- The module caches state per window. As a result, splits genuinely have independent statuslines. The cache clears on `WinClosed`.
- The git segment does not poll. It uses `vim.uv.new_fs_event` to watch `.git/HEAD` directly, and it correctly resolves worktrees and submodules by following the `gitdir: <path>` pointer.
- The module builds separator highlights on demand, by sampling each component's resolved background color, instead of declaring them up front.

### Icons, coloring, and the highlight overrides

`icons.lua` keeps a plain Unicode set and a Nerd Font superset. It merges the two only if `vim.g.use_nerdfonts` is true. `utils/coloring.lua` is a small color-math module used to blend foregrounds into backgrounds, shared by the hover floats, the statusline, and the colorscheme overrides below. `highlights/scheme/kanso.lua` feeds the `overrides` callback in `kanso.nvim`, to remap highlight groups for custom UI elements and plugins onto Kanso's actual palette.

---

## The plugins

### `Pack.add`: The `vim.pack` wrapper

A thin layer over Neovim's native `vim.pack`.
- **Deduplication:** Dependency resolution runs depth-first and removes duplicates.
- **Shorthands:** `gl:user/repo` and `cb:user/repo` resolve to GitLab and Codeberg.
- **Two queues:** Plugins batch up and flush on the next `vim.schedule` tick. Anything marked `sync = true` flushes at once.
- **Setup inference:** If `config` is a table, the module guesses the module name from the repo name, and calls `require(mod).setup(config)` automatically.
- **Build hooks:** These run strictly on `PackChanged`, so they fire only when something actually gets installed or updated.

### Picking, buffers, and navigation

- [artio.nvim](https://github.com/comfysage/artio.nvim)
- [bento.nvim](https://github.com/serhez/bento.nvim)
- [namu.nvim](https://github.com/bassamsdata/namu.nvim)
- [nvim-jump](https://github.com/yorickpeterse/nvim-jump)
- [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf)
- [which-key.nvim](https://github.com/folke/which-key.nvim)

### Git and diffing

- [diffview-plus.nvim](https://github.com/dlyongemallo/diffview-plus.nvim)
- [time-machine.nvim](https://github.com/y3owk1n/time-machine.nvim)

### LSP extras

- [glance.nvim](https://github.com/dnlhc/glance.nvim)
- [live-rename.nvim](https://github.com/saecki/live-rename.nvim)
- [garbage-day.nvim](https://github.com/zahidislm/garbage-day.nvim)
- [codedocs.nvim](https://github.com/jeangiraldoo/codedocs.nvim)
- [vision.nvim](https://github.com/azorng/vision.nvim)

> [!TIP]
> **[cursortab.nvim](https://github.com/cursortab/cursortab.nvim)** is gated behind an environment check. It only queues if `go` is on `$PATH` *and* an `INCEPTION_AI_TOKEN` environment variable is set.

### Tree-sitter

- [tree-sitter-manager.nvim](https://github.com/romus204/tree-sitter-manager.nvim)
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)

### [`mini.nvim`](https://github.com/nvim-mini/mini.nvim)
- [mini.ai](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-ai.md)
- [mini.completion](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-completion.md)
- [mini.diff](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-diff.md)
- [mini.icons](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-icons.md)
- [mini.indentscope](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-indentscope.md)
- [mini.input](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-input.md)
- [mini.keymap](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-keymap.md)
- [mini.move](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-move.md)
- [mini.pairs](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-pairs.md)
- [mini.sessions](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-sessions.md)
- [mini.starter](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-starter.md)
- [mini.surround](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-surround.md)

### Notebooks and Markdown

- [vim-slime](https://github.com/jpalardy/vim-slime) / [ghostty-slime](https://github.com/rkube/ghostty-slime.nvim)
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)

---

## Native LSP

This configuration has no `mason.nvim` and no `nvim-lspconfig` server registry. Every `*.lua` file under `after/lsp/` is simply a `vim.lsp.Config` table, returned directly, following Neovim 0.11+'s native convention. `plugin/05-lsp.lua` scans `vim.api.nvim_get_runtime_file("lsp/*.lua")`, derives each server's name from its filename, and calls `vim.lsp.enable()` on the whole list. To add a language, drop a file in `after/lsp/`. That is the only step.

| Server | Language(s) | Notes |
|---|---|---|
| `clangd` | C, C++, Obj-C, CUDA, Proto | background index, `clang-tidy`, IWYU-style header insertion |
| `ty` + `ruff` | Python | `ty` (via `uvx`) checks types, `ruff` handles lint and format |
| `zls` | Zig | |
| `r_language_server` | R, R Markdown, Quarto | |
| `julials` | Julia | ships a custom `:LspJuliaActivateEnv` command that reproduces the Julia VS Code extension's environment scanning (`JULIA_DEPOT_PATH`, project files) entirely in Lua |
| `marksman` | Markdown | |
| `neocmake` | CMake | |
| `taplo` | TOML | |
| `shuck` | sh, bash, zsh, ksh | |
| `emmylua_ls` | Lua | |
| `commit-lsp` | git commit messages | |

This configuration does not install binaries for you. Whichever servers you actually use must already be on `$PATH`, or fetchable through `uvx` for the Python tools. The `LspAttach` autocmd in `05-lsp.lua` rebinds `gri`/`grr`/`grt`/`grO`/`grn`/`grN`/`grf` to Glance, live-rename, and native formatting, rather than inventing a new keymap convention. It only binds `grf` at all if the attached client actually advertises `documentFormattingProvider`. Inlay hints turn themselves off on `InsertEnter` and back on on `InsertLeave`, so they do not visually conflict with the text you are actively typing.

---

## Snippets without a snippet plugin

`plugin/08-snippet.lua` is the entire engine, and it is about thirty lines long. Each language calls `vimsnip.add()` for its filetype, and `mini.completion` splices in matching entries using Neovim's native `vim.snippet` placeholders (`$0`, `${1}`). I converted most snippets from [friendly-snippets](https://github.com/rafamadriz/friendly-snippets), so kudos to them.

---

## Colorscheme

[`kanso.nvim`](https://github.com/webhooked/kanso.nvim): Loaded synchronously, with `transparent`, `minimal`, and `dimInactive` enabled. The `overrides` callback maps `kanso.nvim`'s palette onto the custom statusline, `namu.nvim`, and the markdown renderer.

---

## Requirements & installation

> [!IMPORTANT]
> This configuration requires Neovim **0.12 or newer**. It relies on `vim.pack`, native `lsp/*.lua` config files, and `vim._core.ui2`, none of which exist on 0.11 or earlier.

- VCS: `git` is currently needed for `vim.pack`. Support for other VCS tools will come soon.
- Whichever **per-language tooling** your `after/lsp/*.lua` files actually point at: `clangd`, `uv`/`uvx` (for `ty`/`ruff`), `R`, `julia`, `taplo`, `zls`, and so on. This configuration does not install any of it for you. There is no Mason here to do it.
- Optionally, a **Go compiler** and an `INCEPTION_AI_TOKEN` environment variable, needed only if you want `cursortab.nvim` to load at all.
- A **Nerd Font**, if you would rather keep `vim.g.use_nerdfonts = true` than fall back to the plain Unicode icon set.

```bash
git clone https://github.com/zahidislm/neovim-config.git ~/.config/nvim
nvim
```

On first launch, `vim.pack` installs everything declared across the `plugin/` directory. The colorscheme and `diffview-plus.nvim` are marked `sync = true`, so they are available immediately, instead of appearing a frame or two late.

---

## Credit where it's due

A few pieces here started as someone else's code, then got adapted to fit this configuration specifically:

- `lua/ui/statuscolumn.lua`: forked from [folke/snacks.nvim](https://github.com/folke/snacks.nvim)'s statuscolumn module.
- `lua/ui/hovers/diagnostics.lua`: forked from [OXY2DEV](https://github.com/OXY2DEV/nvim)'s diagnostics float script.
- `utils.foldexpr()` (in `lua/utils/init.lua`): adapted from [folke](https://github.com/folke) and the [LazyVim](https://github.com/LazyVim/LazyVim) team's work.
- Thanks again to folke, from whose work I learned most of my Lua scripting.
- Thanks to drowning-cat for their [unscope](https://github.com/nvim-mini/mini.nvim/discussions/1951) textobject.
- Thanks to MariaSolOs, a core Neovim maintainer, whose [dotfiles](https://github.com/MariaSolOs/dotfiles/tree/main/.config/nvim) gave me so many ideas, especially for her LSP configs.
- Thanks to comfysage's [sylvee](https://github.com/comfysage/sylvee) project, where I found inspiration for the configuration structure and for their inlay-hint configuration.
- Thanks to nvimdev's [modeline.nvim](https://github.com/nvimdev/modeline.nvim), which gave me the initial inspiration for my statusline implementation.
- Thanks again to OXY2DEV, whose [dotfiles](https://github.com/OXY2DEV/.dotfiles) I forked so many UI components from.
- Thanks to echasnovski's [mini.nvim](https://github.com/nvim-mini/mini.nvim). His work is literally the backbone of my configuration, `vim.pack` included.
- Thanks to the [neovim subreddit](https://reddit.com/r/neovim), where I discovered so many code snippets.
- Thanks to Claude Code for help with debugging and brainstorming ideas, and also for generating the initial version of this README (lol).

I will update this list as I go through my current codebase and find out where each idea came from.

Licensed under [Apache 2.0](LICENSE).
