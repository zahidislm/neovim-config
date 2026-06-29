<div align="center">

# ⏣ neovim-config

![Screenshot of neovim configuration in both light & dark mode](https://i.8upload.com/image/90e83324810d6f10/banner.png)

**A from-scratch Neovim setup built on `vim.pack`, native LSP, and a hand-rolled UI layer.**

![Neovim](https://img.shields.io/badge/Neovim-%E2%89%A50.12-57A143?style=flat-square&logo=neovim&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-000000?style=flat-square&logo=apple&logoColor=F0F0F0)
![License](https://img.shields.io/badge/license-Apache--2.0-blue?style=flat-square)
![Colorscheme](https://img.shields.io/badge/colorscheme-Kans%C5%8D-8a7a99?style=flat-square)

</div>

<br>

## Philosophy

To me, `neovim` is first: a text editor, second: a code editor, third: a diff viewer.

Therefore, my configuration and workflow is designed around that idea.
This configuration doesn't try to do everything nor replace what a multiplexer, terminal, or a proper IDE tries to do. But it does try to make editing text on neovim more enjoyable and convenient (at least to me).

Use a terminal to manage files/directories/structure. Use a multiplexer for complex splits. Use an IDE to debug. Use neovim to edit.

> [!NOTE]
> This is a personal configuration, tuned for one person's workflow on purpose. It isn't a distribution, it doesn't try to be beginner-friendly, and large parts of it exist because I wanted to learn how a particular Neovim internal worked, not because there was no plugin that already did the job. Feel free to read, steal, or fork pieces of it, but I'd think twice before pointing `git clone` straight at `~/.config/nvim` and hoping for the best.

This config does not use `lazy.nvim`, `telescope.nvim`, `mason.nvim`, `blink.cmp`, or `lualine.nvim`. That's not a marketing point; it's just what was left once I started replacing things with Neovim's native equivalents and never really stopped. Plugin management runs on `vim.pack`. Completion runs on `mini.completion` against native LSP, and snippets are about thirty lines of Lua. The statusline, statuscolumn, fold text, quickfix formatting, diagnostics popup, and winbar breadcrumbs are all written by hand and live under `lua/ui/`. Everything else is `mini.nvim` doing the work of what would otherwise be a dozen small plugins.

---

### Contents

- [The UI](#the-ui)
  - [statuscolumn](#statuscolumnlua)
  - [diag-hover](#diag-hoverlua)
  - [breadcrumbs](#breadcrumbslua-lsp-symbols-falling-back-to-tree-sitter)
  - [foldtext](#foldtextlua-folds-that-keep-their-syntax-highlighting)
  - [quickfix](#quickfixlua-a-custom-quickfixtextfunc-handler)
  - [statusline](#statusline-an-event-driven-statusline)
  - [pack-manager](#pack-managerlua-a-dashboard-for-vimpack)
  - [theming](#icons-coloring-and-the-highlight-overrides)
- [Plugins](#the-plugins)
  - [vim.pack wrapper](#packadd-the-vimpack-wrapper)
  - [navigation](#picking-buffers-and-navigation)
  - [VCS](#git-and-diffing)
  - [LSP extras](#lsp-extras)
  - [Tree-sitter](#tree-sitter)
  - [mini.nvim](#mininvim)
  - [Notebooks and Markdown](#notebooks-and-markdown)
- [LSP](#native-lsp)
- [Snippets](#snippets-without-a-snippet-plugin)
- [Colorscheme](#colorscheme)
- [Requirements & installation](#requirements--installation)
- [Credit where it's due](#credit-where-its-due)

---

## The UI

None of this is here because the equivalent plugins are bad. `lualine.nvim`, `noice.nvim`, and friends are all perfectly good. I wrote my own versions mostly as an excuse to actually read the parts of `:help api` I'd otherwise have skipped. A few of them ended up being genuinely better suited to how I work, so they stuck around.

### `statuscolumn.lua`

Forked from [folke/snacks.nvim](https://github.com/folke/snacks.nvim)'s statuscolumn implementation, then trimmed down strictly to marks, signs, git signs, and folds.

### `diag-hover.lua`

A replacement for `vim.diagnostic.open_float()`.

<details>
<summary><b>Expand to see details.</b></summary>
<br>

<picture><img src="https://i.8upload.com/image/df5cbae0ddcdf2d0/screenshot-hover-diag.png" alt="diag-hover screenshot" /></picture>


The interesting part isn't the rendering (which tints the background by severity using an alpha blend), it's the positioning. Rather than always opening below the cursor and occasionally clipping off-screen, it checks four quadrants relative to the cursor and picks the first one that actually fits the screen. It tracks which quadrant is currently occupied so a second float doesn't stack directly on top of the first, and draws border-corner glyphs so the box visually "points" back at the cursor.
</details>

### `breadcrumbs.lua`: LSP symbols, falling back to Tree-sitter

A winbar component to show current symbol.

<details>
<summary><b>Expand to see details.</b></summary>
<br>

<picture><img src="https://i.8upload.com/image/4861067022e098f4/screenshot-breadcrumbs.png" alt="breadcrumbs screenshot" /></picture>

If an attached LSP client supports `textDocument/documentSymbol`, it walks the returned symbol tree to find the symbol path containing the cursor. If nothing's attached, it walks up the Tree-sitter parent chain instead. It matches node types across roughly ten grammars onto a shared set of icon categories, dynamically recovering names for anonymous nodes (like a JS arrow function or Lua `M.foo = function()`) by looking one level up at the enclosing declaration.
</details>

### `foldtext.lua`: Folds that keep their syntax highlighting

A custom (and rather aesthetic) foldtext implementation.

<details>
<summary><b>Expand to see details.</b></summary>
<br>

<picture><img src="https://i.8upload.com/image/6eed6e8054d6f3a2/screenshot-foldtext.png" alt="foldtext screenshot" /></picture>

Neovim's default foldtext just shows the bare first line. This runs the buffer's actual Tree-sitter `highlights` query against the fold's start and end lines, resolving overlapping capture ranges to reassemble the line as a list of `{text, highlight}` chunks. A folded function signature still shows types and keywords in their normal colors.
</details>

### `quickfix.lua`: A custom `quickfixtextfunc` handler

Custom styling & layout for quickfix items.

<details>
<summary><b>Expand to see details.</b></summary>
<br>

<picture><img src="https://i.8upload.com/image/f3b79e67153ac072/screenshot-quickfix.png" alt="quickfix screenshot" /></picture>

Each line gets a diagnostic-severity icon, a `mini.icons` filetype icon, and a path where every interior segment is abbreviated down to one or two characters. Everything lines up into three aligned columns separated by `│`, which doubles as the delimiter `nvim-bqf` expects for its fzf preview filter. It prefers showing the *live* buffer line over the stored item text so a long-running quickfix session reflects edits you've made since the list was built.
</details>

### `statusline`: An event-driven statusline

Designed to be highly efficient in both performance and memory usage:
- Each component declares exactly which autocmd events it cares about. `render.lua` only re-evaluates the components subscribed to that specific event.
- Every component's rendered output is diffed against a cached string before being written. If nothing changed, `redrawstatus` never fires.
- State is cached per-window, so splits genuinely have independent statuslines, and cache is cleared on `WinClosed`.
- The git segment doesn't poll. It uses `vim.uv.new_fs_event` to watch `.git/HEAD` directly, correctly resolving worktrees and submodules by following the `gitdir: <path>` pointer. 
- Separator highlights are synthesized on demand by sampling each component's resolved background color rather than being declared up front.

### `pack-manager.lua`: A dashboard for `vim.pack`

`:Pack` opens a floating-window plugin manager for the native `vim.pack` API. `:Pack check` fetches tags for pinned plugins, finds the newest one, and diffs the commit range looking for Conventional-Commits-style breaking markers (`feat!:`, `fix(scope)!:`, etc.). It allows you to see a breaking change coming *before* it's even tagged.

### Icons, coloring, and the highlight overrides

`icons.lua` keeps a plain Unicode set and a Nerd Font superset, merged only if `vim.g.use_nerdfonts` is true. `highlights/coloring.lua` is a tiny color-math module used to blend foregrounds into backgrounds. `highlights/scheme/kanso.lua` feeds the `overrides` callback in `kanso.nvim` to remap highlight groups for the statusline, `namu.nvim`, and `render-markdown.nvim` onto Kanso's actual palette.

---

## The plugins

### `Pack.add`: The `vim.pack` wrapper

A thin layer over Neovim's native `vim.pack`.
- **Deduplication:** Dependency resolution is depth-first and deduplicated.
- **Shorthands:** `gl:user/repo` and `cb:user/repo` resolve to GitLab and Codeberg.
- **Two queues:** Plugins batch up and flush on the next `vim.schedule` tick, while anything marked `sync = true` flushes immediately.
- **Setup inference:** If `config` is a table, the module name is guessed from the repo name, and `require(mod).setup(config)` is called automatically.
- **Build hooks:** Run strictly on `PackChanged`, so they only fire when something actually gets installed or updated.

### Picking, buffers, and navigation

- **[artio.nvim](https://github.com/comfysage/artio.nvim)**: The primary fuzzy picker, wired into `vim.ui.select` for a unified UI across the editor.
- **[bento.nvim](https://github.com/serhez/bento.nvim)**: Buffer management with a hard cap (`max_open_buffers = 6`) and a "locked" state for pinned buffers.
- **[namu.nvim](https://github.com/bassamsdata/namu.nvim)**: Symbol picker, themed through the Kanso overrides.
- **[nvim-jump](https://github.com/yorickpeterse/nvim-jump)**: Easymotion-style label jumping, bound to bare `s` across normal, visual, and operator-pending modes.
- **[nvim-bqf](https://github.com/kevinhwang91/nvim-bqf)**: Quickfix preview window.

### Git and diffing

**[diffview-plus.nvim](https://github.com/dlyongemallo/diffview-plus.nvim)**: Set to the histogram diff algorithm with a 4-way merge-tool layout. An autocmd hides the cursorline entirely while a Diffview buffer is focused to reduce visual noise.

### LSP extras

- **[glance.nvim](https://github.com/dnlhc/glance.nvim)**: Popup windows bound onto Neovim's default `gr*` keymap conventions.
- **[live-rename.nvim](https://github.com/saecki/live-rename.nvim)**: Interactive in-buffer rename on `grn`/`grN`.
- **[garbage-day.nvim](https://github.com/zahidislm/garbage-day.nvim)**: Kills LSP clients that no longer have attached buffers to save memory.
- **[codedocs.nvim](https://github.com/jeangiraldoo/codedocs.nvim)**: AST-aware doc-comment scaffolding bound to `gca`.
- **[vision.nvim](https://github.com/azorng/vision.nvim)**: A generic editor-context bridge for agentic tools.

> [!TIP]
> **[cursortab.nvim](https://github.com/cursortab/cursortab.nvim)** is gated behind an environment check. It only queues if `go` is on `$PATH` *and* an `INCEPTION_AI_TOKEN` environment variable is set.

### Tree-sitter

- **[tree-sitter-manager.nvim](https://github.com/romus204/tree-sitter-manager.nvim)**: Installs exactly the grammar list declared in `00-nvim-options.lua`. 
- **[nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)**: Wires up structural motions, plus a `@code_cell.inner` motion for jumping between `# %%`-style Jupyter notebook cells.

### `mini.nvim`

Eleven submodules configured in one block. A handful of pieces are hand-built on top:

<details>
<summary><b>A hand-written subword text object</b></summary>
<br>

`mini.ai`'s custom `e` text object is built from Lua frontier patterns rather than a single regex, so it correctly bounds `snake_case`, `kebab-case`, and `CamelCase` segments independently without mishandling segment boundaries. There's also a custom digit object (`d`) and an HTML tag object (`t`).
</details>

<details>
<summary><b>Completions</b></summary>
<br>

`mini.completion` is wired directly to native LSP completion. `process_items()` strips noisy fields and splices in entries from the homegrown snippet registry, explicitly prioritizing snippets over standard text suggestions.
</details>

<details>
<summary><b>An indent-scope-aware operator on <code>S</code></b></summary>
<br>

A custom operator-pending mapping that treats `mini.indentscope` as a structural region. Allows you to delete/change/yank around an indentation scope.
</details>

<details>
<summary><b><code>:</code> replaced by mini.input</b></summary>
<br>

`mini.input` doubles as the generic `vim.ui.input()` handler *and* a full replacement for the command line, complete with Vimscript-aware syntax highlighting and auto-detected password masking.
</details>

<details>
<summary><b>Why mini.surround isn't on <code>s</code></b></summary>
<br>

Since bare `s` belongs to `nvim-jump`, `mini.surround` defaults are remapped to `ys`/`ds`/`cs`, utilizing custom padded surroundings for brackets so `ysiw(` produces `( word )` rather than `(word)`.
</details>

### Notebooks and Markdown

- **[jupynvim](https://github.com/sheng-tse/jupynvim)**: Runs actual Jupyter kernels inside Neovim. 
- **[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)**: Lazy-loaded the first time a markdown-adjacent filetype is opened, rendering thick block-style heading borders and a code-block UI with language pills.

---

## Native LSP

There's no `mason.nvim` and no `nvim-lspconfig` server registry in this config. Every `*.lua` file under `after/lsp/` is just a `vim.lsp.Config` table, returned directly, per Neovim 0.11+'s native convention. `plugin/05-lsp.lua` scans `vim.api.nvim_get_runtime_file("lsp/*.lua")`, derives each server's name from its filename, and calls `vim.lsp.enable()` on the whole list, adding a language is "drop a file in `after/lsp/`," full stop.

| Server | Language(s) | Notes |
|---|---|---|
| `clangd` | C, C++, Obj-C, CUDA, Proto | background index, `clang-tidy`, IWYU-style header insertion |
| `ty` + `ruff` | Python | `ty` (via `uvx`) for type checking, `ruff` for lint/format |
| `zls` | Zig | |
| `r_language_server` | R, R Markdown, Quarto | |
| `julials` | Julia | ships a custom `:LspJuliaActivateEnv` command that reimplements the Julia VS Code extension's environment scanning (`JULIA_DEPOT_PATH`, project files) entirely in Lua |
| `marksman` | Markdown | |
| `neocmake` | CMake | |
| `taplo` | TOML | |
| `shuck` | sh, bash, zsh, ksh | |
| `emmylua_ls` | Lua | |
| `commit-lsp` | git commit messages | |

Binaries aren't installed for you. Whichever servers you actually use need to already be on `$PATH`, or fetchable through `uvx` for the Python tools. The `LspAttach` autocmd in `05-lsp.lua` rebinds `gri`/`grr`/`grt`/`grO`/`grn`/`grN`/`grf` to Glance/live-rename/native formatting rather than inventing a new keymap convention, and only binds `grf` at all if the attached client actually advertises `documentFormattingProvider`. Inlay hints turn themselves off on `InsertEnter` and back on on `InsertLeave`, so they don't visually fight with what you're actively typing.

---

## Snippets without a snippet plugin

`plugin/08-snippet.lua` is the entire engine, and it's about thirty lines long. Each language calls `vimsnip.add()` for its filetype, and `mini.completion` splices in matching entries using Neovim's native `vim.snippet` placeholders (`$0`, `${1}`). Most snippets were converted from [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) so kudos to them.

---

## Colorscheme

[`kanso.nvim`](https://github.com/webhooked/kanso.nvim): Loaded synchronously with `transparent`, `minimal`, and `dimInactive` enabled. The `overrides` callback maps `kanso.nvim`'s palette perfectly onto the custom statusline, `namu.nvim`, and markdown renderer.

---

## Requirements & installation

> [!IMPORTANT]
> Neovim **0.12 or newer** is required. This config leans on `vim.pack`, native `lsp/*.lua` config files, and `vim._core.ui2`, none of which exist on 0.11 or earlier.

- VCS: currently `git` is needed for vim.pack. `jj` support to come soon.
- Whichever **per-language tooling** your `after/lsp/*.lua` files actually point at. `clangd`, `uv`/`uvx` (for `ty`/`ruff`), `R`, `julia`, `taplo`, `zls`, and so on. None of it is installed for you; there's no Mason here to do it.
- Optionally, **Go compiler** and an `INCEPTION_AI_TOKEN` environment variable, only if you want `cursortab.nvim` to load at all.
- A **Nerd Font**, if you'd rather keep `vim.g.use_nerdfonts = true` than fall back to the plain Unicode icon set.

```bash
git clone https://github.com/zahidislm/neovim-config.git ~/.config/nvim
nvim
```

On first launch, `vim.pack` will install everything declared across the `plugin/` directory. The colorscheme and `diffview-plus.nvim` are marked `sync = true`, so they're available immediately rather than appearing a frame or two late.

---

## Credit where it's due

A few pieces here started as someone else's code, then got bent into shape for this config specifically:

- `lua/ui/statuscolumn.lua`: forked from [folke/snacks.nvim](https://github.com/folke/snacks.nvim)'s statuscolumn module.
- `lua/ui/diag-hover.lua`: forked from [OXY2DEV](https://github.com/OXY2DEV/nvim)'s diagnostics float script.
- `utils.foldexpr()` (in `lua/utils/init.lua`): adapted from [folke](https://github.com/folke) and the [LazyVim](https://github.com/LazyVim/LazyVim) team's efforts.
- once more to folke, where I learned most of my lua scripting from.
- drowning-cat for their [unscope](https://github.com/nvim-mini/mini.nvim/discussions/1951) textobject.
- MariaSolOs's (core neovim maintainer!) [dotfiles](https://github.com/MariaSolOs/dotfiles/tree/main/.config/nvim) where I got so, so, so many inspirations from especially for her LSP configs.
- comfysage's [sylvee](https://github.com/comfysage/sylvee) project where I took inspiration for the config structure and for their inlayhint configuration.
- nvimdev's [modeline.nvim](https://github.com/nvimdev/modeline.nvim), where I got the initial inspiration for my statusline implementation.
- once more, OXY2DEV's [dotfiles](https://github.com/OXY2DEV/.dotfiles) where I forked so many UI components from.
- echasnovski's [mini.nvim](https://github.com/nvim-mini/mini.nvim). His work is literally the backbone of my configuration. vim.pack included.
- and the [neovim subreddit](https://reddit.com/r/neovim) where so many code snippets were discovered.
- Claude Code for helping me debug and brainstorm ideas, and also generating the initial version of this README (lol)

Will update this list as I go through my current codebase and figure out where I got the inspirations from!

Licensed under [Apache 2.0](LICENSE).
