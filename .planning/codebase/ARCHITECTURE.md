<!-- refreshed: 2026-05-16 -->
# Architecture

**Analysis Date:** 2026-05-16

## System Overview

```text
┌─────────────────────────────────────────────────────────────┐
│              ~/.dotfiles (git repository)                    │
│  Root config files + neovim/ + scripts/ + claude/           │
└──────┬──────────────────┬─────────────────┬─────────────────┘
       │                  │                 │
       ▼                  ▼                 ▼
┌────────────┐   ┌────────────────┐  ┌───────────────┐
│  Symlinks  │   │  Symlinks to   │  │  Symlinks to  │
│ ~/.zshrc   │   │ ~/.config/nvim │  │ ~/.claude/    │
│ ~/.tmux    │   │  (neovim/ dir) │  │ settings.json │
│ ~/.gitconfig│  └────────────────┘  └───────────────┘
└────────────┘
                         │
                         ▼
          ┌──────────────────────────────┐
          │     neovim/ (Lua config)     │
          ├────────────┬─────────────────┤
          │ lua/core/  │  lua/plugins/   │
          │ options    │  (31 plugins)   │
          │ keymaps    ├─────────────────┤
          │ lazy       │  lua/config/    │
          └────────────┤  (26 configs)   │
                       ├─────────────────┤
                       │    lsp/         │
                       │  (13 servers)   │
                       └─────────────────┘
```

## Component Responsibilities

| Component | Responsibility | File |
|-----------|----------------|------|
| Install script | Clones repo, creates all symlinks, bootstraps dependencies | `scripts/install_dotfiles.sh` |
| Neovim entry point | Loads core modules in order, bootstraps lazy.nvim | `neovim/init.lua` |
| Core options | Fundamental editor settings (tabs, folds, UI, clipboard) | `neovim/lua/core/options.lua` |
| Core keymaps | General keybindings not tied to specific plugins | `neovim/lua/core/keymaps.lua` |
| lazy.nvim bootstrap | Installs lazy.nvim if absent, auto-discovers plugins from `lua/plugins/` | `neovim/lua/core/lazy.lua` |
| Plugin definitions | Thin lazy.nvim return tables: declares plugin, event, dependencies, calls config | `neovim/lua/plugins/*.lua` |
| Plugin configs | Full plugin setup, keybindings, theme integration | `neovim/lua/config/*.lua` |
| LSP global config | Blink.cmp capabilities, diagnostic UI, LspAttach keymaps, `vim.lsp.enable()` | `neovim/lua/config/lsp.lua` |
| LSP server configs | Per-server settings auto-loaded by `vim.lsp.enable()` | `neovim/lsp/*.lua` |
| Shell config | Oh My Zsh, Starship, plugins, path setup | `.zshrc`, `.zprofile`, `.zsh_aliases` |
| Tmux config | Prefix, pane bindings, Catppuccin theme, TPM plugins | `.tmux.conf` |
| Claude config | Permissions, hooks, GSD workflow integration, statusline | `claude/settings.json` |

## Pattern Overview

**Overall:** Symlink-based dotfiles with a modular Lua Neovim config

**Key Characteristics:**
- All config files live in `~/.dotfiles` and are symlinked to their expected locations by `scripts/install_dotfiles.sh`
- Neovim uses a strict two-file pattern: a thin plugin declaration (`lua/plugins/X.lua`) delegates all configuration to a full config file (`lua/config/X.lua`)
- LSP uses Neovim's built-in `vim.lsp` API — NOT nvim-lspconfig
- lazy.nvim auto-discovers all plugin files by scanning `lua/plugins/` (no manual registration required)
- Catppuccin Mocha theme is applied consistently across Neovim, Tmux, Ghostty, and Starship

## Layers

**Dotfiles installation layer:**
- Purpose: Provision the system — clone repo, create symlinks, install oh-my-zsh, TPM, set up gitconfig.local
- Location: `scripts/install_dotfiles.sh`
- Contains: Bash functions, one per tool
- Depends on: `scripts/utils/print.sh`, `scripts/utils/folders.sh`
- Used by: Invoked manually on a fresh macOS machine

**Neovim core layer:**
- Purpose: Editor fundamentals — settings, keymaps, plugin manager bootstrap
- Location: `neovim/lua/core/`
- Contains: `options.lua`, `keymaps.lua`, `lazy.lua`
- Depends on: Nothing (loaded before plugins)
- Used by: `neovim/init.lua` (required first)

**Plugin declaration layer:**
- Purpose: Declare plugins to lazy.nvim with lazy-loading triggers (events, commands, filetypes)
- Location: `neovim/lua/plugins/`
- Contains: 31 thin Lua files, each returning a lazy.nvim spec table
- Depends on: lazy.nvim (scanned automatically)
- Used by: lazy.nvim at startup

**Plugin configuration layer:**
- Purpose: Full setup logic for each plugin — options, mappings, theme integration
- Location: `neovim/lua/config/`
- Contains: 26 detailed Lua config files
- Depends on: The plugin being loaded
- Used by: Plugin declaration files via `require('config.X')`

**LSP server configuration layer:**
- Purpose: Per-server overrides — root markers, filetypes, settings, on_init/on_attach hooks
- Location: `neovim/lsp/`
- Contains: 13 Lua files (one per language server)
- Depends on: Neovim built-in `vim.lsp`, Mason-installed binaries
- Used by: `vim.lsp.enable()` in `neovim/lua/config/lsp.lua` (auto-loaded by name)

## Data Flow

### Neovim Startup

1. `neovim/init.lua` — requires `core/options`, `core/keymaps`, `core/lazy` in order
2. `neovim/lua/core/lazy.lua` — bootstraps lazy.nvim, calls `require('lazy').setup({ spec = { import = 'plugins' } })`
3. lazy.nvim scans `neovim/lua/plugins/*.lua` — builds plugin registry
4. Each plugin file calls `require('config.X')` inside its `config` function when the plugin loads
5. `neovim/lua/plugins/lsp.lua` fires on `BufReadPre`/`BufNewFile` events → loads `neovim/lua/config/lsp.lua`
6. `neovim/lua/config/lsp.lua` calls `vim.lsp.config('*', ...)` then `vim.lsp.enable({...})` — Neovim auto-loads matching files from `neovim/lsp/*.lua`

### Install / Provisioning

1. User runs `scripts/install_dotfiles.sh`
2. Script clones repo to `~/.dotfiles` (or pulls if already present)
3. For each tool: creates symlink from dotfiles location to expected system path
4. Bootstraps oh-my-zsh, TPM, creates `~/.gitconfig.local` from user input

## Key Abstractions

**Plugin/Config split:**
- Purpose: Keep lazy.nvim spec tables thin; isolate full configuration complexity
- Pattern: `neovim/lua/plugins/X.lua` returns only spec + `config = function() require('config.X') end`
- Examples: `neovim/lua/plugins/telescope.lua` → `neovim/lua/config/telescope.lua`

**LSP pseudo-plugin:**
- Purpose: Treat the LSP setup as a lazy.nvim plugin so it loads on file events (not at startup)
- Pattern: `neovim/lua/plugins/lsp.lua` uses `dir = vim.fn.stdpath('config')` to reference the local config dir
- File: `neovim/lua/plugins/lsp.lua`

**Per-server LSP files:**
- Purpose: Each language server has its own Lua file returning a config table consumed by `vim.lsp.enable()`
- Pattern: File name matches the server name exactly (e.g. `vtsls.lua` for `vtsls`)
- Location: `neovim/lsp/*.lua`

## Entry Points

**Neovim:**
- Location: `neovim/init.lua`
- Triggers: Neovim startup (symlinked to `~/.config/nvim/init.lua`)
- Responsibilities: Load core modules in order

**Shell:**
- Location: `.zshrc`
- Triggers: New interactive zsh session
- Responsibilities: Load oh-my-zsh, Starship, aliases, path exports

**Install:**
- Location: `scripts/install_dotfiles.sh`
- Triggers: Manual invocation on a new machine
- Responsibilities: Full system provisioning

## Architectural Constraints

- **Symlink dependency:** All configs assume they are symlinked from `~/.dotfiles` to their expected locations. Files must remain in their repo paths.
- **LSP binary locations:** LSP server configs reference Mason's install prefix via `vim.fn.stdpath('data') .. '/mason/...'`. Mason must be installed and servers provisioned via `:Mason` before LSP works.
- **Vue hybrid mode:** `vtsls` and `vue_ls` must both be active simultaneously for Vue TypeScript support. Removing either breaks the pair.
- **lazy.nvim auto-discovery:** All files in `neovim/lua/plugins/` are automatically loaded. Adding a file to that directory registers it as a plugin spec immediately.
- **gitconfig.local:** `~/.gitconfig.local` is excluded from the repo. It is created interactively by `scripts/install_dotfiles.sh` and must exist for git to have user identity.
- **Global state:** `vim.g.have_nerd_font = true` is set in `neovim/lua/core/options.lua` and referenced by plugin definitions (e.g. `neovim/lua/plugins/telescope.lua`).

## LSP Architecture Detail

Neovim's built-in `vim.lsp` API is used — not the `nvim-lspconfig` community plugin.

```
vim.lsp.config('*', { capabilities = blink_caps, root_markers = {...} })
    ↓ (applies to all servers)
vim.lsp.enable({ 'vtsls', 'vue_ls', 'lua_ls', ... })
    ↓ (for each name, auto-loads neovim/lsp/<name>.lua)
neovim/lsp/vtsls.lua  →  returns { cmd, root_markers, filetypes, settings, on_attach }
neovim/lsp/vue_ls.lua →  returns { cmd, filetypes, on_init (tsserver bridge) }
...
    ↓
LspAttach autocmd fires per buffer
    → sets buffer-local keymaps (gd, gr, gi, K, <leader>ca, <leader>rn, etc.)
    → populates workspace diagnostics via workspace-diagnostics plugin
```

**Vue LSP (hybrid mode):**
- `vtsls.lua` includes `vue` filetype and loads `@vue/typescript-plugin` via `globalPlugins`
- `enableForWorkspaceTypeScriptVersions = true` is required when `autoUseWorkspaceTsdk = true`
- `vue_ls.lua` implements the `tsserver/request` bridge in `on_init` (mandatory in vue-language-server v3)
- `root_markers` in `vtsls.lua` excludes `.git` to prevent anchoring to git root instead of the `tsconfig.json` dir

## Anti-Patterns

### Adding nvim-lspconfig

**What happens:** Installing and using `nvim-lspconfig` alongside `vim.lsp.enable()`
**Why it's wrong:** Creates a duplicate LSP management layer; conflicts with per-server files in `neovim/lsp/`
**Do this instead:** Add a new server by creating `neovim/lsp/<servername>.lua`, adding the name to `vim.lsp.enable()` in `neovim/lua/config/lsp.lua`, and installing the binary via Mason

### Inline plugin configuration

**What happens:** Putting full plugin setup logic inside the `config` function in `neovim/lua/plugins/X.lua`
**Why it's wrong:** Breaks the plugin/config split pattern; makes plugin declarations hard to scan
**Do this instead:** Keep `neovim/lua/plugins/X.lua` thin (spec + `require('config.X')`), put all logic in `neovim/lua/config/X.lua`

### Editing files at their symlink targets directly

**What happens:** Editing `~/.zshrc` or `~/.config/nvim/...` directly instead of the dotfiles source
**Why it's wrong:** Changes are made outside the git repo and will be lost or overwritten on next install
**Do this instead:** Always edit files in `~/.dotfiles/` — changes are immediately reflected via symlinks

## Error Handling

**Strategy:** Silent-fail with print feedback in install script; Lua config errors surface as Neovim startup messages

**Patterns:**
- Install script uses `|| return 1` on critical operations and `print_error`/`print_success` helpers
- LSP config guards existence of Mason plugin path before constructing `vue_plugin` table (`neovim/lsp/vtsls.lua` lines 11-17)
- lazy.nvim reports plugin load errors in its UI

## Cross-Cutting Concerns

**Theme:** Catppuccin Mocha applied in `neovim/lua/config/catppuccin.lua`, `.tmux.conf` (via TPM), `ghostty.config`, and `starship.toml`
**Completion:** Blink.cmp (`neovim/lua/config/blink.lua`) is the single completion engine; LSP, Codeium, snippets, path, and buffer all feed into it
**Formatting:** conform.nvim (`neovim/lua/config/conform.lua`) handles all formatting; intentionally separate from LSP

---

*Architecture analysis: 2026-05-16*
