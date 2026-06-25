# ⏣ Neovim Configuration

> [!NOTE]
> An optimized, personal Neovim environment. Built around the principles of *Kansō* (簡素)—simplicity and the elimination of clutter—this setup leverages the bleeding-edge features of Neovim 1.12+ and the native Lua API to deliver a lightweight, high-performance editing experience.

## Core Philosophy

This configuration abandons heavy, off-the-shelf frameworks in favor of meticulously hand-crafted components. It is designed for developers who want absolute control over their editor's performance, memory footprint, and visual hierarchy.

- **Native Package Management:** Complete deprecation of third-party package managers (like `lazy.nvim` or `packer.nvim`) in favor of a custom, highly advanced `vim.pack` wrapper.
- **Kansō Aesthetic:** A minimalist, distraction-free visual language that uses hex-code precise color blending and custom highlight groups rather than standard terminal colors.
- **Performance First:** Extensive use of caching, Lua bytecode optimization (`vim.loader`), and FFI (Foreign Function Interface) calls for UI rendering.

---

## UI Elements (`lua/ui/`)

Instead of relying on heavy plugins like `lualine` or `noice`, this configuration implements its own tailored UI components, heavily integrated with the *Kansō* colorscheme.

### 1. High-Performance Statuscolumn (`statuscolumn.lua`)
Forked and optimized from Snacks.nvim, this custom statuscolumn displays marks, git signs, and folds. 
* **Unique Trait:** It bypasses standard Vimscript evaluations by utilizing raw C FFI calls (`fold_info`) to calculate fold depth, ensuring zero-latency scrolling even in massive files.

### 2. Fancy Diagnostics Hover (`diag-hover.lua`)
Replaces the standard floating diagnostics window with a richly formatted hover element.
* **Unique Trait:** Dynamically generates highlight groups based on your current colorscheme. It seamlessly blends diagnostic colors (Error, Warn, Info) into the background using a precise `alpha = 0.1` ratio, providing a soft, non-intrusive visual cue.

### 3. AST-Driven Breadcrumbs (`breadcrumbs.lua`)
A custom winbar component that tracks your current code context.
* **Unique Trait:** Combines LSP Document Symbols and Tree-sitter node traversal. It caches `mini.icons` and dynamically maps complex Tree-sitter grammar scopes (like Rust `impl` blocks or JavaScript `arrow_functions`) into clean, unified UI icons.

### 4. Custom Statusline (`statusline/`)
A highly modular, component-based statusline
* **Unique Trait:** Deeply integrated with `lua/ui/highlights/scheme/kanso.lua`. The statusline is fully mode-aware, dynamically shifting its background colors based on Vim modes while caching Git daemon outputs to prevent rendering bottlenecks.

### 5. Formatted Quickfix Menu (`quickfix.lua`)
A custom `quickfixtextfunc` implementation.
* **Unique Trait:** Cleans up the traditionally messy quickfix window by injecting `mini.icons` and formatting columns perfectly. It is strictly configured to use a `│` delimiter, ensuring flawless integration with `nvim-bqf` (Better Quickfix) and `fzf`.

### 6. Native Pack Manager Dashboard (`pack-manager.lua`)
A complete UI dashboard (`:Pack`) built entirely from scratch for the native Neovim 0.12+ `vim.pack` API.
* **Unique Trait:** Features asynchronous Git log integration that parses semantic versioning (SemVer). It proactively scans repositories to alert you of *breaking changes* in unreleased commits before you update your plugins.

---

## Plugin Ecosystem

The plugin architecture is strictly declarative and loaded via the custom `Pack.add()` API found in `plugin/07-pack.lua`.

<details>
<summary><b>Editor Operations</b> (Click to expand)</summary>

* **`artio.nvim`**: Replaces Telescope and Fzf-lua as the primary fuzzy finder. Configured seamlessly to handle files, commands, grep, and help tags via a clean, minimalist UI (`win = { hidestatusline = true }`).
* **`bento.nvim`**: An aggressive, opinionated buffer manager. It strictly enforces a `max_open_buffers = 6` rule with locked priorities, ensuring your workspace never becomes cluttered with forgotten files.
</details>

<details>
<summary><b>Coding & AI Integration</b></summary>

* **`cursortab.nvim`**: A custom-built AI completion tool. Rather than using standard Copilot plugins, this utilizes a custom Golang server built locally during the plugin's `build` step, communicating with a Mercury API provider via the `INCEPTION_AI_TOKEN`.
* **`codedocs.nvim`**: Streamlines documentation by generating intelligent AST-aware annotations for the object currently under the cursor (`gca`).
</details>

<details>
<summary><b>Text Objects (`mini.nvim`)</b></summary>

* **Advanced `mini.ai`**: The configuration heavily extends `mini.ai` with complex, custom regex patterns. It introduces highly specific text objects for digits (`d`) and highly accurate sub-word navigation (`e`) that perfectly handles `_`, `-`, and CamelCase boundaries. 
</details>

---

## Requirements & Installation

> [!IMPORTANT]
> This configuration relies heavily on bleeding-edge Neovim features. Ensure your environment meets the following criteria before installation.

1. **Neovim 0.12 (or newer)**: Required for the updated `vim.pack` API and native Lua features.
2. **macOS**: Certain system integrations and font renderings are optimized for macOS environments.
3. **Golang**: Required to build the local server for `cursortab.nvim`.
4. **Environment Variables**: Export `INCEPTION_AI_TOKEN` in your shell (e.g., Zsh) for AI code completion functionality.

### Setup

```bash
# Clone directly into your Neovim configuration directory
git clone https://github.com/zahidislm/neovim-config.git ~/.config/nvim

# Open Neovim — The custom pack manager will initialize automatically
nvim
```
