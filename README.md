<div align="center">

# ⏣ neovim-config

**A from-scratch Neovim setup built on `vim.pack`, native LSP, and a hand-rolled UI layer.**

![Neovim](https://img.shields.io/badge/Neovim-%E2%89%A50.12-57A143?style=flat-square&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-100%25-2C2D72?style=flat-square&logo=lua&logoColor=white)
![License](https://img.shields.io/badge/license-Apache--2.0-blue?style=flat-square)
![Colorscheme](https://img.shields.io/badge/colorscheme-Kans%C5%8D-8a7a99?style=flat-square)

</div>

<br>

> [!NOTE]
> This is a personal configuration, tuned for one person's workflow on purpose. It isn't a distribution, it doesn't try to be beginner-friendly, and large parts of it exist because I wanted to learn how a particular Neovim internal worked, not because there was no plugin that already did the job. Feel free to read, steal, or fork pieces of it, but I'd think twice before pointing `git clone` straight at `~/.config/nvim` and hoping for the best.

This config does not use `lazy.nvim`, `telescope.nvim`, `mason.nvim`, `blink.cmp`, or `lualine.nvim`. That's not a marketing point, it's just what was left once I started replacing things with Neovim 0.12's native equivalents one at a time and never really stopped. Plugin management runs on `vim.pack`. Completion runs on `mini.completion` against native LSP. Snippets are about thirty lines of Lua. The statusline, statuscolumn, fold text, quickfix formatting, diagnostics popup, and winbar breadcrumbs are all written by hand and live under `lua/ui/`. Everything else is `mini.nvim` doing the work of what would otherwise be a dozen small plugins.

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

None of this is here because the equivalent plugins are bad. `lualine.nvim`, `noice.nvim`, `incline.nvim`, and friends are all perfectly good. I wrote my own versions of most of them at different points over the last year, mostly as an excuse to actually read the parts of `:help api` and `:help lua-guide` I'd otherwise have skipped. A few of them ended up being genuinely better suited to how I work than the plugin equivalent, so they stuck around.

### `statuscolumn.lua`

 It's forked from [folke/snacks.nvim](https://github.com/folke/snacks.nvim)'s statuscolumn implementation, then trimmed down to just marks, signs, git signs, and folds.
### `diag-hover.lua`

A replacement for `vim.diagnostic.open_float()`. The interesting part isn't the rendering (wrap diagnostic text, tint the background by severity using an alpha blend against `Normal`'s actual background color), it's the positioning. Rather than always opening below the cursor and occasionally clipping off-screen, `__win_args()` checks four quadrants relative to the cursor in priority order: bottom-right, top-right, bottom-left, top-left. It picks the first one that actually fits the screen, and tracks which quadrant is currently occupied in a global table so a second float doesn't stack directly on top of the first. Each quadrant gets its own border-corner glyphs so the box visually "points" back at the cursor regardless of which side it landed on. Forked from [OXY2DEV](https://github.com/OXY2DEV/nvim)'s diagnostics script and then rewired to regenerate its highlight groups on every `ColorScheme` event instead of hardcoding colors.

### `breadcrumbs.lua`: LSP symbols, falling back to Tree-sitter

A winbar component. If an attached LSP client supports `textDocument/documentSymbol`, it walks the returned symbol tree to find the path of symbols containing the cursor. If nothing's attached, it walks up the Tree-sitter parent chain instead, matching node types against a table that maps `function_declaration` / `function_definition` / `function_item` / `class_specifier` / `impl_item` / and so on across roughly ten grammars onto a shared set of icon categories, so a Rust `impl_item` and a Python `class_definition` both render through the same "struct" icon lookup. The trickier bit is naming anonymous nodes: a JS arrow function or a Lua `M.foo = function()` doesn't have a name field on the node itself, so `extract_scope_name()` looks one level up at the enclosing `variable_declarator` / `assignment_statement` and recovers the name from there instead of just printing "function".

### `foldtext.lua`: folds that keep their syntax highlighting

Neovim's default foldtext just shows the bare first line. This one runs the buffer's actual Tree-sitter `highlights` query against the fold's start and end lines specifically (not the whole buffer), does a sweep-line merge of overlapping capture ranges by priority to figure out which highlight wins at each column, and reassembles the line as a list of `{text, highlight}` chunks. So a folded function signature still shows types and keywords in their normal colors instead of collapsing into one flat color. Results are cached per buffer/line/text so re-folding something you've already folded once is free, and the cache is cleared on `BufWipeout` so it doesn't leak.

### `quickfix.lua`: a custom `quickfixtextfunc` handler

A custom `quickfixtextfunc` (and separately, `loclist`) renderer. Each line gets a diagnostic-severity icon, a `mini.icons` filetype icon, and a path where every interior segment is abbreviated down to one or two characters, except for the first and last segments and anything matching a small allow-list of "don't shorten this" patterns (currently just anything ending in `nvim`, so the config's own directory name stays legible). Everything lines up into three aligned columns separated by `│`, which doubles as the delimiter `nvim-bqf` expects from its fzf preview filter, so the two integrate without extra config on either side. For the quickfix list specifically, it prefers showing the *live* buffer line over the stored item text when the buffer is loaded, so a long-running quickfix session reflects edits you've made since the list was built rather than a stale snapshot.

### `statusline`:  an event-driven statusline

This is the largest piece of the UI layer. The design goal was to be efficient both in perf and memory uage *while* looking good:

- Each component  declares exactly which autocmd events it cares about. `render.lua` only registers the union of events actually requested by the components in your config, and on each event only re-evaluates the components subscribed to it.
- Every component's rendered output is diffed against a cached "pill" string before being written anywhere. If nothing changed, `redrawstatus` never fires.
- State is cached per-window (`cache.win[winid]`), so splits genuinely have independent statuslines, and that cache is cleared on `WinClosed` rather than left to grow for the life of the session.
- The git segment doesn't poll. `providers/git_daemon.lua` uses `vim.uv.new_fs_event` to watch `.git/HEAD` directly and only recomputes branch state when HEAD actually changes. It also resolves worktrees and submodules correctly by following the `gitdir: <path>` pointer file rather than assuming `.git` is always a directory. Diff counts (added/changed/removed) are read opportunistically from whichever of `gitsigns`, `mini.diff`, or `mini.git` happens to be loaded, in that order.
- Highlights live in their own light/dark palette in `highlight.lua` and get regenerated on `ColorScheme`/`VimResume`/`UIEnter`; separator highlights between pills are synthesized on demand by sampling each component's *actual* resolved background color rather than being declared up front, and cleared via LuaJIT's `table.clear` so cache invalidation doesn't leave garbage for the GC to walk.

### `pack-manager.lua`: a dashboard for `vim.pack`

`:Pack` opens a floating-window plugin manager for the native `vim.pack` API (update, delete, clean unloaded plugins, view git log) per plugin. The part that doesn't exist anywhere else is `:Pack check` (mapped to `C`): for any plugin pinned to a semver tag, it fetches tags, finds the newest one, and diffs the commit range between your current tag and that target looking for Conventional-Commits-style breaking markers (`feat!:`, `fix(scope)!:`, etc.). Separately, it checks whether the upstream default branch already has unreleased breaking commits sitting past the latest tag, so you can see a breaking change coming *before* it's even tagged, not just after you've already updated into it. Unversioned, rolling plugins get a simpler HEAD-vs-remote-HEAD diff. All of the git calls run concurrently through `vim.system`, and the buffer is rendered with extmark highlights rather than plain text so loaded/unloaded/breaking states are visually distinct at a glance.

### Icons, coloring, and the highlight overrides

`icons.lua` keeps two parallel tables: a plain Unicode set that renders correctly in any terminal, and a Nerd Font superset, merged over the plain set only if `vim.g.use_nerdfonts` is true. `highlights/coloring.lua` is a tiny color-math module from scratch. `parse()` normalizes hex strings, decimal color numbers, RGB triplets, or even functions-that-return-colors into a plain RGB array; `blend()` alpha-mixes a foreground into a background (used by the diagnostics popup and the Markdown heading backgrounds); `gradient()` interpolates an N-step array between two colors. `highlights/scheme/kanso.lua` is what's handed to the `overrides` callback in `kanso.nvim`'s setup that remaps roughly fifty highlight groups belonging to the statusline, `namu.nvim`, and `render-markdown.nvim` onto Kanso's actual palette, computing the Markdown heading backgrounds at runtime with `blend()` instead of hardcoding hex values, so they stay correct across the dark/light variant switch.

---

## The plugins

### `Pack.add`: the `vim.pack` wrapper

`plugin/07-pack.lua` is a thin layer over Neovim's native `vim.pack`, not a replacement for it. A spec is just `{ "user/repo", version = "...", data = { ... } }`, where `data` holds everything *this* wrapper cares about: `init`, `config`, `main`, `build`, `keys`, `dependencies`, `sync`. It's all kept separate from `vim.pack`'s own spec fields so the two don't collide.

A few things it does that I didn't want to give up after switching off `lazy.nvim`:

- **Dependency resolution is depth-first and deduplicated.** If two plugins both declare the same dependency, it's only queued once.
- **Shorthand hosts.** `gl:user/repo` and `cb:user/repo` resolve to GitLab and Codeberg; anything else with no scheme is assumed to be a GitHub `user/repo`.
- **Two queues.** Most plugins batch up and flush on the next `vim.schedule` tick, so calling `Pack.add` repeatedly during startup doesn't fire a `vim.pack.add` call per plugin. Anything marked `sync = true` (or pulled in as a dependency of something sync) flushes immediately.
- **Setup inference.** If `config` is a table rather than a function, the module name is guessed from the repo name (`nvim-`, `lua-`, and `.nvim` are stripped off first) and `require(mod).setup(config)` is called automatically. You only write `main = "..."` explicitly when the guess would be wrong.
- **Build hooks run on `PackChanged`**, not at spec-declaration time, so a `build` step only fires when something actually got installed or updated, and failures get a `vim.notify` instead of disappearing into a log file you forgot existed.

### Picking, buffers, and navigation

- **[artio.nvim](https://github.com/comfysage/artio.nvim)**: the fuzzy picker, also wired into `vim.ui.select` so any plugin that just asks Neovim for a generic selector gets the same UI as the dedicated file/grep/command pickers.
- **[bento.nvim](https://github.com/serhez/bento.nvim)**: buffer management with a hard cap (`max_open_buffers = 6`) and a "locked" state for pinned buffers that don't count against the cap, plus custom open/delete/split/bookmark actions registered through its action API rather than the plugin's defaults.
- **[namu.nvim](https://github.com/bassamsdata/namu.nvim)**: symbol picker, themed through the Kanso overrides above.
- **[nvim-jump](https://github.com/yorickpeterse/nvim-jump)**: easymotion-style label jumping, bound to bare `s` across normal, visual, and operator-pending modes.
- **[nvim-bqf](https://github.com/kevinhwang91/nvim-bqf)**: quickfix preview window.

### Git and diffing

**[diffview-plus.nvim](https://github.com/dlyongemallo/diffview-plus.nvim)**: loaded synchronously, set to the histogram diff algorithm, a file panel that always shows the branch name, and a 4-way merge-tool layout that cycles through 3-way, horizontal, and plain on demand. There's a small autocmd pair here that hides the cursor entirely while a Diffview buffer is focused and restores it on `WinLeave` — the default cursorline inside Diffview's file list is mostly visual noise once you're navigating it with the plugin's own keymaps.

### LSP extras

- **[glance.nvim](https://github.com/dnlhc/glance.nvim)**: popup windows for references/implementations/type-definitions/definitions, bound onto Neovim's own `gri`/`grr`/`grt`/`grO` default keymap convention rather than inventing new ones.
- **[live-rename.nvim](https://github.com/saecki/live-rename.nvim)**: interactive in-buffer rename on `grn`/`grN`, only bound at all if the attached client's `renameProvider` capability is actually present.
- **[garbage-day.nvim](https://github.com/zahidislm/garbage-day.nvim)**: Kills LSP clients that no longer have any attached buffers instead of leaving them resident in memory for the rest of the session.
- **[codedocs.nvim](https://github.com/jeangiraldoo/codedocs.nvim)**: AST-aware doc-comment scaffolding under the cursor, bound to `gca`.
- **[vision.nvim](https://github.com/azorng/vision.nvim)**: a generic editor-context bridge for agentic tools

> [!TIP]
> **[cursortab.nvim](https://github.com/cursortab/cursortab.nvim)** is the only plugin in this config gated behind an environment check. It's only added to the queue at all if `go` is on `$PATH` *and* an `INCEPTION_AI_TOKEN` environment variable is set, its `build` step compiles a small local Go server that talks to a `mercuryapi` completion provider. No token and no Go toolchain means the plugin is never even queued, not just disabled.

### Tree-sitter

- **[tree-sitter-manager.nvim](https://github.com/romus204/tree-sitter-manager.nvim)**: installs exactly the grammar list declared once in `vim.g.enabled_syntax_languages` (`00-nvim-options.lua`), so adding a language to the config is a one-line change rather than a separate `:TSInstall`. 

- **[nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)**: wires up parameter/function/class/fold motions, plus a `@code_cell.inner` motion for jumping between `# %%`-style notebook cells, a detail that only makes sense once you've also seen the Jupyter integration further down.

### `mini.nvim`

Eleven submodules configured in one block in `plugin/22-mini-plugins.lua`: `ai`, `completion`, `diff`, `icons`, `indentscope`, `input`, `keymap`, `move`, `pairs`, `sessions`, `surround`. Most of it is the documented defaults with sane option choices, but a handful of pieces are genuinely hand-built on top:

<details>
<summary><b>A hand-written subword text object</b></summary>
<br>

`mini.ai`'s custom `e` text object is built from about a dozen Lua frontier patterns rather than a single regex, specifically so it correctly bounds `snake_case`, `kebab-case`, and `CamelCase` segments independently, most "subword" implementations I've tried get one of the three right and quietly mishandle the others at segment boundaries. There's also a plain digit text object (`d`) and an HTML tag object (`t`) sitting next to the usual Tree-sitter-backed `function`/`class`/`block` objects.

</details>

<details>
<summary><b>Completions</b></summary>
<br>

`mini.completion` is wired directly to native LSP completion. No completion-engine abstraction layer in between. `process_items()` strips noisy `detail`/`labelDetails` fields and splices in entries from the homegrown snippet registry (more on that below), with plain-`Text` suggestions deprioritized and `Snippet` entries boosted so a snippet trigger doesn't get buried under word-completion noise.

</details>

<details>
<summary><b>An indent-scope-aware operator on <code>S</code></summary>
<br>

A custom operator-pending mapping treats the current `mini.indentscope` as a structural region: delete or change inside it while leaving the border lines intact, or toggle a comment (`g@S`) across everything inside the scope without touching its border. None of that ships with `mini.indentscope` itself, it's built directly against `MiniIndentscope.get_scope()` and the buffer line API.

</details>

<details>
<summary><b><code>:</code> replaced by mini.input</b></summary>
<br>

`mini.input` doubles as the generic `vim.ui.input()` handler *and* a full replacement for the command line, bound straight onto the `:` key, with Vimscript-aware syntax highlighting applied to whatever you're typing and password-style masking auto-detected from the prompt text (anything matching `[Pp]assword` gets `hide = true`).

</details>

<details>
<summary><b>Why mini.surround isn't on <code>s</code></summary>
<br>

Bare `s` belongs to `nvim-jump`'s motion plugin in this config, so `mini.surround`'s defaults (`s`/`ys`/`ds`/`cs`) got remapped to `ys`/`ds`/`cs` specifically to free it up, with custom padded surroundings for brackets so `ysiw(` produces `( word )` rather than `(word)`.

</details>

### Notebooks and Markdown

- **[jupynvim](https://github.com/sheng-tse/jupynvim)**: runs actual Jupyter kernels inside Neovim, with its own post-install step invoked through `build`. 
- **[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)**: is deliberately *not* loaded eagerly. It's pulled in the first time any markdown-adjacent filetype (`markdown`, `norg`, `org`, `rmd`, `quarto`, `typst`) is opened, through a `FileType` autocmd that calls `vim.pack.add` directly. It's configured with thick block-style heading borders and a code-block UI with language pills on either side, set up to feel closer to an IDE preview than a typical rendered-markdown plugin.

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

`plugin/08-snippet.lua` is the entire engine, and it's about thirty lines long. Each `after/ftplugin/<lang>.lua` file calls `vimsnip.add({ trigger = body, ... })` once for its filetype. `mini.completion` calls `vimsnip.get_items(base)` on every keystroke and splices in matching entries shaped exactly like LSP `CompletionItem`, so there's no separate trigger key, no dedicated snippet UI, and no snippet syntax beyond Neovim's own native `vim.snippet` placeholders (`$0`, `${1:default}`), which `mini.keymap`'s Tab multistep already knows how to jump between.

Snippets are declared in the `after/ftplugin` file for each individual language.
Most of it was converted from [friendly-snippets](https://github.com/rafamadriz/friendly-snippets), so kudos to them!

---

## Colorscheme

[`kanso.nvim`](https://github.com/webhooked/kanso.nvim): (dark variant `ink`, light variant `pearl`), loaded synchronously with `transparent`, `minimal`, and `dimInactive` all on. The `overrides` callback passed into its setup is the `highlights/scheme/kanso.lua` file described above. It's what makes the custom statusline, `namu.nvim`, and the Markdown renderer all read their colors from Kanso's actual palette instead of falling back to whatever defaults those plugins ship with.

---

## Requirements & installation

> [!IMPORTANT]
> Neovim **0.12 or newer** is required. This config leans on `vim.pack`, native `lsp/*.lua` config files, and `vim._core.ui2`, none of which exist on 0.11 or earlier.

- **Neovim ≥ 0.12**,
- **git**
- Whichever **per-language tooling** your `after/lsp/*.lua` files actually point at. `clangd`, `uv`/`uvx` (for `ty`/`ruff`), `R`, `julia`, `taplo`, `zls`, and so on. None of it is installed for you; there's no Mason here to do it.
- Optionally, **Go** and an `INCEPTION_AI_TOKEN` environment variable, only if you want `cursortab.nvim` to load at all.
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
- MariaSolOs's (core neovim maintainer!) [dotfiles](https://github.com/MariaSolOs/dotfiles/tree/main/.config/nvim) where I got so, so, so many inspirations from especially for her LSP configs.
- nvimdev's [modeline.nvim](https://github.com/nvimdev/modeline.nvim), where I got the initial inspiration for my statusline implementation.
- once more, OXY2DEV's [dotfiles](https://github.com/OXY2DEV/.dotfiles) where I forked so many UI components from.
- echasnovski's [mini.nvim](https://github.com/nvim-mini/mini.nvim). His work is literally the backbone of my configuration. vim.pack included.
- and the [neovim subreddit](https://reddit.com/r/neovim) where so many code snippets were discovered.
- Claude Code for helping me debug and brainstorm ideas, and also generating the initial version of this README (lol)

Will update this list as I go through my current codebase and figure out where I got the inspirations from!

Licensed under [Apache 2.0](LICENSE).
