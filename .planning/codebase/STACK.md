# Technology Stack

**Analysis Date:** 2026-05-16

## Languages

**Primary:**
- Lua — Neovim configuration (`neovim/init.lua`, `neovim/lua/`)
- Bash/Zsh — Shell configs and scripts (`.zshrc`, `.zsh_aliases`, `.bash_aliases`, `scripts/`)

**Secondary:**
- TOML — Starship prompt config (`starship.toml`)
- YAML — Lazygit config (`config.yml`)
- JSON / JSONC — Claude settings (`claude/settings.json`), Opencode settings (`opencode.jsonc`), lazy-lock (`neovim/lazy-lock.json`)

## Runtime

**Environment:**
- macOS (Darwin 25.x) — primary target; Linux compatible for most configs
- Neovim — Lua runtime for all editor config (requires Neovim with built-in LSP support, i.e. 0.11+)
- Node.js v24.15.0 (via fnm) — used by Claude Code hooks in `claude/settings.json`

**Package Manager (macOS):**
- Homebrew — system-level tool installation; `uu` alias runs `brew update && brew upgrade && brew autoremove && brew cleanup`

## Frameworks & Plugin Managers

**Neovim:**
- `lazy.nvim` (stable branch, commit `306a054`) — plugin manager; auto-discovers plugins from `neovim/lua/plugins/`
  - Config: `neovim/lua/core/lazy.lua`
  - Lockfile: `neovim/lazy-lock.json`
  - Update checker enabled, change detection disabled

**Tmux:**
- TPM (Tmux Plugin Manager) — installed at `~/.tmux/plugins/tpm`
  - Config: `.tmux.conf`
  - Plugins pinned in `.tmux.conf` with `set -g @plugin`

**Zsh:**
- Oh My Zsh — framework installed at `~/.oh-my-zsh`
  - Active plugins: `git`, `zsh-syntax-highlighting`, `zsh-autosuggestions`
  - Additional plugins installed by `scripts/install_dotfiles.sh`: `zsh-completions`, `zsh-history-substring-search`

## Key Neovim Plugins (from `neovim/lazy-lock.json`)

**Completion:**
- `blink.cmp` — modern async completion engine replacing nvim-cmp; config `neovim/lua/config/blink.lua`
  - Sources (priority order): LSP (120), lazydev (90), Codeium (85), snippets (50), path (10), buffer (-20)
- `friendly-snippets` — general snippet collection
- `vscode-es7-javascript-react-snippets` — JS/React/TS snippets
- `hollowtree/vscode-vue-snippets` — Vue 3 snippets
- `cstrap/python-snippets` — Python snippets

**LSP:**
- `mason.nvim` + `mason-tool-installer.nvim` — LSP/formatter installer; config `neovim/lua/config/mason.lua`
- `lazydev.nvim` — Lua LSP workspace for Neovim config development
- `workspace-diagnostics.nvim` — populates diagnostics for all project files on LSP attach

**AI Assistants:**
- `codeium.nvim` (enabled) — free AI completion; integrated via Blink.cmp; config `neovim/lua/config/codeium.lua`
- `supermaven-nvim` (enabled) — AI inline completion; accept via `<C-l>`; config `neovim/lua/config/supermaven.lua`
- `github/copilot.vim` (enabled, disabled by default at runtime) — GitHub Copilot; toggled via `<leader>ac`
- `ChatGPT.nvim` (disabled — conflicts with Avante) — OpenAI GPT-4o integration

**UI:**
- `catppuccin` — Mocha theme; config `neovim/lua/config/catppuccin.lua`
- `lualine.nvim` — status line; config `neovim/lua/config/lualine.lua`
- `bufferline.nvim` — buffer/tab bar with diagnostics; config `neovim/lua/config/bufferline.lua`
- `noice.nvim` — enhanced UI for messages/cmdline; config `neovim/lua/config/noice.lua`
- `nvim-notify` — notification pop-ups; config `neovim/lua/config/notify.lua`
- `tiny-inline-diagnostic.nvim` — inline LSP diagnostics (replaces `virtual_text`); config `neovim/lua/config/inline-diagnostic.lua`
- `nvim-web-devicons` — file type icons
- `snacks.nvim` — multi-feature plugin (dashboard, lazygit, image preview, scroll, statuscolumn, git, gh); config `neovim/lua/config/snacks.lua`

**Navigation & Search:**
- `telescope.nvim` + `telescope-fzf-native.nvim` + `telescope-ui-select.nvim` — fuzzy finder; config `neovim/lua/config/telescope.lua`
- `neo-tree.nvim` (v3.x branch) — file explorer; config `neovim/lua/config/neotree.lua`
- `flash.nvim` — motion/jump; config `neovim/lua/config/flash.lua`
- `which-key.nvim` — keybinding help popup; config `neovim/lua/config/which-key.lua`
- `trouble.nvim` — diagnostics/references list; config `neovim/lua/config/trouble.lua`

**Editing:**
- `conform.nvim` — code formatting on save; config `neovim/lua/config/conform.lua`
- `Comment.nvim` — comment toggling; config `neovim/lua/config/comment.lua`
- `mini.nvim` — used selectively (auto-pairs via `auto-pairs.lua`)
- `guess-indent.nvim` — auto-detect indentation; plugin file `neovim/lua/plugins/auto-indent.lua`

**Syntax:**
- `nvim-treesitter` (main branch) — syntax highlighting + folding; config `neovim/lua/config/treesitter.lua`
  - Parsers: lua, css, vue, php, html, scss, json, bash, rust, regex, javascript, typescript, java

**Git:**
- `gitsigns.nvim` — in-buffer git hunks; config `neovim/lua/config/gitsigns.lua`
- Lazygit integration via `snacks.nvim` (`Snacks.lazygit()`)

**Debugging:**
- `nvim-dap` + `nvim-dap-ui` + `nvim-dap-go` — DAP debug adapter; config `neovim/lua/config/debugging.lua`
- `nvim-jdtls` — Java LSP + DAP; config `neovim/lua/config/jdtls.lua`
- `neotest` + `neotest-java` — test runner (Java only, lazy-loaded on `ft = java`); config `neovim/lua/config/neotest.lua`

**Utilities:**
- `plenary.nvim` — Lua utility library (dependency for many plugins)
- `nui.nvim` — UI component library (dependency)
- `nvim-nio` — async I/O library (DAP dependency)
- `luvit-meta` — Lua type annotations for `vim.*` APIs

## LSP Servers (Neovim built-in LSP via `vim.lsp.enable`)

Enabled in `neovim/lua/config/lsp.lua`, per-server configs in `neovim/lsp/`:

| Server | Language | Config File |
|--------|----------|-------------|
| `vtsls` | TypeScript/JavaScript/Vue | `neovim/lsp/vtsls.lua` |
| `vue_ls` | Vue (hybrid mode) | `neovim/lsp/vue_ls.lua` |
| `lua_ls` | Lua | `neovim/lsp/lua_ls.lua` |
| `basedpyright` | Python | `neovim/lsp/basedpyright.lua` |
| `ruff` | Python (lint/format) | `neovim/lsp/ruff.lua` |
| `rust_analyzer` | Rust | `neovim/lsp/rust_analyzer.lua` |
| `clangd` | C/C++ | `neovim/lsp/clangd.lua` |
| `css_ls` | CSS | `neovim/lsp/css_ls.lua` |
| `html_ls` | HTML | `neovim/lsp/html_ls.lua` |
| `jsonls` | JSON | `neovim/lsp/jsonls.lua` |
| `eslint_ls` | JS/TS lint | `neovim/lsp/eslint_ls.lua` |
| `bashls` | Bash | `neovim/lsp/bashls.lua` |
| `marksman` | Markdown | `neovim/lsp/marksman.lua` |
| `dockerls` | Dockerfile | (no custom config) |
| `jdtls` | Java | `neovim/lua/config/jdtls.lua` (nvim-jdtls) |

**Note:** LSP uses Neovim's built-in `vim.lsp.enable` / `vim.lsp.config` — not nvim-lspconfig.

## Formatters (via conform.nvim)

Managed by Mason; configured in `neovim/lua/config/conform.lua`:
- `prettier` — Vue, CSS, HTML, YAML, JSON, Markdown, JS, TS, JSX, TSX
- `stylua` — Lua
- `ruff_format` + `ruff_organize_imports` — Python (custom stdin-based formatter args)

## Tmux Plugins

Configured in `.tmux.conf`:
- `tmux-plugins/tpm` — Tmux Plugin Manager
- `catppuccin/tmux#v2.1.3` — Catppuccin Mocha theme (pinned version)
- `tmux-plugins/tmux-sensible` — sensible defaults
- `christoomey/vim-tmux-navigator` — commented out / disabled

## Terminal Tools

- **Ghostty** — terminal emulator; config `ghostty.config` (Catppuccin Mocha theme, MesloLGS NF font, size 15)
- **Starship** — cross-shell prompt; config `starship.toml` (Catppuccin Mocha palette, multi-language segments)
- **Fastfetch** — system info on shell startup (`[[ $SHLVL -eq 1 ]] && fastfetch` in `.zshrc`)
- **bat** — cat replacement (`alias cat='bat'` in `.zsh_aliases`)
- **colorls** — ls replacement with color/icons (`alias ll='colorls -lah'`)
- **lazygit** — TUI git client; config `config.yml` (Catppuccin Mocha colors, delta pager)
- **delta** — git diff pager with syntax highlighting; config embedded in `.gitconfig`
  - Features: `catppuccin-mocha colorblind-diff`
- **git-lfs** — large file storage; registered in `.gitconfig`
- **Opencode** — AI coding TUI; config `opencode.jsonc`
- **Claude Code** — AI coding CLI; config `claude/settings.json`

## Configuration

**Symlink-based deployment:**
- Install script: `scripts/install_dotfiles.sh`
- All configs are symlinked from `~/.dotfiles/` to their expected system locations
- Symlink targets: `~/.zshrc`, `~/.zprofile`, `~/.zsh_aliases`, `~/.gitconfig`, `~/.tmux.conf`, `~/.config/nvim`, `~/.config/starship.toml`, `~/.config/ghostty/config`, `~/.config/lazygit/config.yml`, `~/.config/opencode/opencode.jsonc`, `~/.claude/settings.json`

**Git personal info:**
- Kept in `~/.gitconfig.local` (untracked); `.gitconfig` includes it via `[include] path = ~/.gitconfig.local`

**Node.js version management:**
- fnm — Node.js version manager; v24.15.0 used for Claude Code hooks

---

*Stack analysis: 2026-05-16*
