# Testing Patterns

**Analysis Date:** 2026-05-16

## Overview

This is a personal dotfiles repository. There are no automated tests, no test files, no CI/CD pipelines, and no test framework configuration. All validation is manual and performed by the developer after making changes.

## Automated Testing

**Test files:** None. `find` returns no `*.test.*` or `*.spec.*` files anywhere in the repository.

**CI/CD:** No `.github/` directory exists. No GitHub Actions workflows, no CircleCI, no other pipeline configs.

**Test frameworks:** None installed or configured.

## How Changes Are Validated

### Neovim Configuration

**Full reload** — restart Neovim entirely after changes. This is the safest method and ensures lazy.nvim re-evaluates all plugin specs.

**In-session reload** — for config files only (not plugin spec changes):
```
:source %                  -- reload the current file
:source ~/.config/nvim/lua/config/<name>.lua
```

**Lazy.nvim plugin reload:**
```
:Lazy reload <plugin-name>  -- hot-reload a specific plugin
:Lazy sync                  -- update all plugins
:Lazy check                 -- check for plugin updates
```

**LSP validation** after changes to `neovim/lsp/*.lua` or `neovim/lua/config/lsp.lua`:
```
:LspInfo                   -- inspect active servers and their config
:LspLog                    -- view LSP server output and errors
:LspRestart                -- restart all active LSP clients
```
Keybindings for these are `<leader>li`, `<leader>ll`, `<leader>lr`.

**Lua syntax check** before committing:
```bash
nvim --headless -c 'lua print("ok")' -c 'qa'
luacheck neovim/lua/    # if luacheck is installed
```

### Shell Configuration

**Reload `.zshrc`:**
```bash
source ~/.zshrc
```

**Reload `.zsh_aliases`:**
```bash
source ~/.zsh_aliases
```

**Test install script** (dry-run approach — review output before applying):
```bash
bash scripts/install_dotfiles.sh
```
The install script is idempotent for most operations: it checks for existing directories/files before overwriting and prints status for each step.

**Validate symlinks:**
```bash
ls -la ~/.zshrc ~/.zsh_aliases ~/.tmux.conf ~/.gitconfig ~/.config/nvim
```

### Tmux Configuration

**Reload tmux config** (prefix is `Ctrl+A`):
```
Ctrl+A then r
```

Or from shell:
```bash
tmux source-file ~/.tmux.conf
```

### Starship Prompt

Changes to `starship.toml` take effect on the next shell session or after:
```bash
source ~/.zshrc
```

## Neotest (In-Editor Test Runner)

While the dotfiles repo itself has no tests, Neovim is configured with Neotest for running tests in projects being edited. This is configured in `neovim/lua/config/neotest.lua` with the `neotest-java` adapter.

**Neotest keybindings** (available when editing project files):

| Key | Action |
|-----|--------|
| `<leader>nr` | Run nearest test |
| `<leader>nf` | Run test file |
| `<leader>nd` | Debug nearest test (via DAP) |
| `<leader>ns` | Stop running test |
| `<leader>no` | Show test output |
| `<leader>np` | Toggle output panel |
| `<leader>nm` | Toggle test summary |
| `[n` | Jump to previous failed test |
| `]n` | Jump to next failed test |

Config: `neovim/lua/plugins/neotest.lua`, `neovim/lua/config/neotest.lua`

## DAP (Debug Adapter Protocol)

Neovim is configured with nvim-dap for debugging projects. This is not used for testing the dotfiles themselves. Config: `neovim/lua/config/debugging.lua`.

**DAP keybindings:**

| Key | Action |
|-----|--------|
| `<leader>dt` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>ds` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dr` | Open REPL |
| `<leader>du` | Toggle DAP UI |

## Common Change Validation Workflow

When making changes to this repository, follow this sequence:

1. Make the change in the relevant file
2. For Neovim Lua changes: restart Neovim, or use `:source` / `:Lazy reload` for quick iteration
3. For LSP changes: `:LspRestart` and verify with `:LspInfo`
4. For shell changes: `source ~/.zshrc` in a new terminal tab
5. For tmux changes: `Ctrl+A r` inside a tmux session
6. Verify the changed behavior works as expected manually
7. Commit the change

## Notes on Dotfiles Testability

- Neovim config errors surface immediately on startup as Lua errors in the notification area (handled by noice.nvim + notify.nvim)
- LSP server issues surface via `:LspLog` and `:LspInfo`
- lazy.nvim reports plugin load errors in its UI (`:Lazy`)
- Shell syntax errors surface when sourcing the file
- The install script uses explicit success/failure output for each step, acting as a self-documenting smoke test

---

*Testing analysis: 2026-05-16*
