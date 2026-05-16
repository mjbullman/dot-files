# Codebase Structure

**Analysis Date:** 2026-05-16

## Directory Layout

```
~/.dotfiles/
├── neovim/                     # Neovim configuration (symlinked → ~/.config/nvim)
│   ├── init.lua                # Entry point: loads core/, bootstraps lazy.nvim
│   ├── lazy-lock.json          # lazy.nvim lockfile (committed, tracks exact plugin versions)
│   ├── lsp/                    # Per-server LSP configs (auto-loaded by vim.lsp.enable)
│   └── lua/
│       ├── core/               # Editor fundamentals (loaded before plugins)
│       ├── plugins/            # Plugin declarations (lazy.nvim auto-discovers these)
│       ├── config/             # Full plugin configurations (required by plugin files)
│       └── snippets/           # Custom snippet files (currently empty)
├── scripts/                    # Bash scripts for provisioning
│   ├── install_dotfiles.sh     # Primary install script: symlinks all dotfiles
│   └── utils/
│       ├── print.sh            # Colored output helpers (print_success, print_error, etc.)
│       └── folders.sh          # Directory creation utilities
├── claude/                     # Claude Code settings (symlinked → ~/.claude/)
│   ├── settings.json           # Permissions, hooks, GSD workflow config, theme
│   └── statusline-command.sh   # Shell command for Claude statusline display
├── .claude/                    # Claude project-level settings (NOT symlinked)
│   └── settings.local.json     # Local overrides for Claude permissions
├── .planning/                  # GSD planning documents (not symlinked)
│   └── codebase/               # Codebase map documents (ARCHITECTURE.md, STRUCTURE.md, etc.)
├── .w3m/                       # w3m browser config
├── .zshrc                      # Zsh main config (symlinked → ~/.zshrc)
├── .zprofile                   # Zsh profile/path exports (symlinked → ~/.zprofile)
├── .zsh_aliases                # Shell aliases (symlinked → ~/.zsh_aliases)
├── .bash_aliases               # Bash aliases (legacy, not symlinked by install script)
├── .gitconfig                  # Git config (symlinked → ~/.gitconfig); includes ~/.gitconfig.local
├── .gitignore                  # Repo gitignore
├── .tmux.conf                  # Tmux config (symlinked → ~/.tmux.conf)
├── .p10k.zsh                   # Powerlevel10k config (legacy; Starship is active)
├── starship.toml               # Starship prompt config (symlinked → ~/.config/starship.toml)
├── ghostty.config              # Ghostty terminal config (symlinked → ~/.config/ghostty/config)
├── config.yml                  # Lazygit config (symlinked → ~/.config/lazygit/config.yml)
├── opencode.jsonc              # Opencode AI config (symlinked → ~/.config/opencode/opencode.jsonc)
├── neofetch.conf               # Neofetch config (symlinked → ~/.config/neofetch/neofetch.conf)
├── iterm2.config.plist         # iTerm2 config (not symlinked by install script)
├── CLAUDE.md                   # Claude Code project instructions
├── GEMINI.md                   # Gemini AI project instructions
└── README.md                   # Repository documentation
```

## Directory Purposes

**`neovim/lsp/`:**
- Purpose: One Lua file per LSP server, returning a config table consumed by `vim.lsp.enable()`
- Contains: `vtsls.lua`, `vue_ls.lua`, `lua_ls.lua`, `clangd.lua`, `css_ls.lua`, `eslint_ls.lua`, `basedpyright.lua`, `bashls.lua`, `html_ls.lua`, `jsonls.lua`, `marksman.lua`, `ruff.lua`, `rust_analyzer.lua`
- Key files: `neovim/lsp/vtsls.lua` (Vue/TS hybrid), `neovim/lsp/vue_ls.lua` (Vue tsserver bridge)
- Naming rule: filename must match the server name passed to `vim.lsp.enable()`

**`neovim/lua/core/`:**
- Purpose: Editor fundamentals loaded before any plugin
- Contains: `options.lua` (editor settings), `keymaps.lua` (general keybindings), `lazy.lua` (lazy.nvim bootstrap + plugin scan)
- Load order: options → keymaps → lazy (enforced by `neovim/init.lua`)

**`neovim/lua/plugins/`:**
- Purpose: Thin lazy.nvim spec tables — declare each plugin with its event triggers, dependencies, and a config function
- Contains: 31 files (one per plugin or plugin group)
- Pattern: Each file ends with `config = function() require('config.X') end`
- Key files: `neovim/lua/plugins/lsp.lua` (LSP pseudo-plugin), `neovim/lua/plugins/blink.lua` (completion), `neovim/lua/plugins/telescope.lua` (fuzzy finder)

**`neovim/lua/config/`:**
- Purpose: Full plugin configuration — all options, keybindings, theme integration for a given plugin
- Contains: 26 files
- Key files: `neovim/lua/config/lsp.lua` (LSP global setup + all LspAttach keymaps), `neovim/lua/config/blink.lua` (completion engine setup), `neovim/lua/config/catppuccin.lua` (theme), `neovim/lua/config/bufferline.lua`, `neovim/lua/config/which-key.lua`

**`scripts/`:**
- Purpose: Bash automation for provisioning and utilities
- Contains: `install_dotfiles.sh` (full system setup), `utils/print.sh` (output helpers), `utils/folders.sh` (directory helpers)

**`claude/`:**
- Purpose: Claude Code settings tracked in the dotfiles repo and symlinked to `~/.claude/`
- Contains: `settings.json` (permissions, hooks, GSD workflow integration), `statusline-command.sh` (statusline script)

**`.claude/`:**
- Purpose: Claude project-specific settings for the dotfiles repo itself (not symlinked; not for provisioning)
- Contains: `settings.local.json` (local permission overrides)

**`.planning/codebase/`:**
- Purpose: GSD workflow codebase map documents, generated by `/gsd:map-codebase`
- Contains: ARCHITECTURE.md, STRUCTURE.md, and other analysis documents
- Generated: Yes (by GSD agents)
- Committed: Yes

## Key File Locations

**Entry Points:**
- `neovim/init.lua`: Neovim startup entry point
- `scripts/install_dotfiles.sh`: System provisioning entry point
- `.zshrc`: Shell session entry point

**Configuration:**
- `neovim/lua/core/options.lua`: All Neovim editor options
- `neovim/lua/core/keymaps.lua`: General keybindings
- `neovim/lua/core/lazy.lua`: lazy.nvim bootstrap and plugin scan
- `neovim/lua/config/lsp.lua`: Global LSP setup, diagnostic config, all LspAttach keymaps
- `.gitconfig`: Git settings (includes `~/.gitconfig.local` for identity)
- `claude/settings.json`: Claude Code permissions and GSD hooks

**Core Logic:**
- `neovim/lua/config/blink.lua`: Completion engine configuration
- `neovim/lua/config/catppuccin.lua`: Theme definition
- `neovim/lsp/vtsls.lua`: TypeScript/Vue LSP (hybrid mode)
- `neovim/lsp/vue_ls.lua`: Vue language server (tsserver bridge)

**Install Utilities:**
- `scripts/utils/print.sh`: Colored output functions used throughout install script
- `scripts/utils/folders.sh`: Directory creation helpers

## Naming Conventions

**Files:**
- Neovim Lua files: `kebab-case.lua` for multi-word names (e.g. `inline-diagnostic.lua`, `auto-pairs.lua`, `which-key.lua`)
- LSP server files: match the server name exactly as passed to `vim.lsp.enable()` (e.g. `vue_ls.lua`, `eslint_ls.lua`)
- Shell config files: dot-prefixed lowercase (e.g. `.zshrc`, `.zsh_aliases`, `.tmux.conf`)
- Root tool configs: lowercase with tool-appropriate extension (e.g. `starship.toml`, `ghostty.config`, `config.yml`)

**Directories:**
- Lua subdirectories: lowercase single word (`core`, `plugins`, `config`)
- Top-level directories: lowercase (`neovim`, `scripts`, `claude`)

## Where to Add New Code

**New Neovim plugin:**
1. Create plugin declaration: `neovim/lua/plugins/<plugin-name>.lua` — return lazy.nvim spec with `config = function() require('config.<plugin-name>') end`
2. Create full config: `neovim/lua/config/<plugin-name>.lua` — all setup logic here
3. lazy.nvim auto-discovers it; no registration needed

**New LSP server:**
1. Create `neovim/lsp/<servername>.lua` returning `{ cmd, root_markers, filetypes, settings }`
2. Add the server name string to the list in `vim.lsp.enable({...})` in `neovim/lua/config/lsp.lua`
3. Install the binary via `:Mason` in Neovim

**New shell alias:**
- Add to `.zsh_aliases`

**New shell path or environment setup:**
- Add to `.zprofile` (evaluated at login, before `.zshrc`)

**New provisioning step:**
- Add a `install_<tool>()` function to `scripts/install_dotfiles.sh`
- Call it from `main()` at the bottom of the file
- Use `print_success`/`print_error`/`print_banner` from `scripts/utils/print.sh`

**New root tool config file:**
- Add the file to the repo root
- Add a corresponding `install_<tool>_config()` function in `scripts/install_dotfiles.sh` that creates the symlink

## Special Directories

**`.git/`:**
- Purpose: Git version control
- Generated: Yes
- Committed: No

**`neovim/snippets/`:**
- Purpose: Custom snippet files for Blink.cmp
- Generated: No
- Committed: Yes (currently empty)

**`.planning/`:**
- Purpose: GSD workflow planning state (phases, codebase maps)
- Generated: Yes (by GSD agents)
- Committed: Yes

**`.w3m/`:**
- Purpose: w3m text browser configuration
- Generated: No
- Committed: Yes

## Symlink Map (installed by `scripts/install_dotfiles.sh`)

| Dotfiles source | Installed to |
|----------------|-------------|
| `neovim/` | `~/.config/nvim` |
| `.zshrc` | `~/.zshrc` |
| `.zprofile` | `~/.zprofile` |
| `.zsh_aliases` | `~/.zsh_aliases` |
| `.gitconfig` | `~/.gitconfig` |
| `.tmux.conf` | `~/.tmux.conf` |
| `starship.toml` | `~/.config/starship.toml` |
| `ghostty.config` | `~/.config/ghostty/config` |
| `config.yml` | `~/.config/lazygit/config.yml` and `~/Library/Application Support/lazygit/config.yml` |
| `opencode.jsonc` | `~/.config/opencode/opencode.jsonc` |
| `neofetch.conf` | `~/.config/neofetch/neofetch.conf` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `claude/statusline-command.sh` | `~/.claude/statusline-command.sh` |

---

*Structure analysis: 2026-05-16*
