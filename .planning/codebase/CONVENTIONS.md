# Coding Conventions

**Analysis Date:** 2026-05-16

## File Header Pattern

Every Lua file opens with a banner comment identifying the file's purpose and author. Use the exact format seen throughout the codebase:

```lua
-- ==============================
-- [Plugin/Component] [Plugin Setup | Configuration]
-- Author: Martin Bullman
-- ==============================
```

Plugin definition files use "Plugin Setup" in the title. Config files use "Configuration". LSP files use "LSP Config". Core files use the setting name (e.g., "Core Neovim Setup Options").

Shell scripts use a full block header with dashes, author, purpose description, plugin list, and last-updated date:

```bash
###############################################################################
#                         [TITLE]                                              #
# --------------------------------------------------------------------------- #
# Author        : Martin Bullman                                              #
# Purpose       : [description]                                               #
# Last Updated : YYYY-MM-DD                                                   #
###############################################################################
```

## Naming Patterns

**Lua files:**
- Plugin definitions: `kebab-case.lua` matching the plugin's common name (e.g., `which-key.lua`, `auto-pairs.lua`, `inline-diagnostic.lua`)
- Config files: `kebab-case.lua` mirroring the plugin file name exactly (e.g., `neotree.lua` pairs with `config/neotree.lua`)
- LSP server configs: `snake_case.lua` matching the LSP server identifier used in `vim.lsp.enable()` (e.g., `vue_ls.lua`, `lua_ls.lua`, `vtsls.lua`)
- Core files: `snake_case.lua` (e.g., `options.lua`, `keymaps.lua`, `lazy.lua`)

**Shell scripts:**
- `snake_case.sh` (e.g., `install_dotfiles.sh`, `dev_env.sh`)
- Utility functions: `snake_case` with verb prefix (e.g., `print_success`, `folder_exists`, `install_gitconfig`)

**Shell variables:**
- Script-level constants: `UPPER_SNAKE_CASE` (e.g., `SCRIPT_DIR`, `DOTFILES_DIR`, `SESSION_NAME`)
- Color constants: `UPPER_SNAKE_CASE` (e.g., `RED_TEXT`, `GREEN_TEXT`, `RESET_TEXT`)
- Local function variables: `lower_snake_case` (e.g., `folder_path`, `custom_plugins`, `tpm_dir`)

**Lua locals:**
- Module-level shortcuts: `local map = vim.keymap.set`, `local opts = { noremap = true, silent = true }`
- Plugin references: lowercase abbreviated name (e.g., `local dap = require('dap')`, `local neotest = require('neotest')`)
- Palette references: `local c = require('catppuccin.palettes').get_palette('mocha')`

## Plugin Definition vs Config Split

All plugin definitions live in `neovim/lua/plugins/*.lua`. Each file returns a single lazy.nvim spec table. Complex configs are always extracted to `neovim/lua/config/*.lua` and loaded via `require('config.<name>')` inside the `config = function()` callback.

**Plugin definition template (always use `config` function, not `opts`):**
```lua
return {
    'author/plugin-name',
    dependencies = { ... },
    config = function()
        require('config.pluginname')
    end,
}
```

The `opts` shorthand is not used — all plugins call `require('config.<name>')` explicitly. This keeps setup logic in one predictable location.

**Config file pattern — call `.setup()` directly, no wrapper function:**
```lua
-- ==============================
-- Plugin Configuration
-- Author: Martin Bullman
-- ==============================

require('plugin-name').setup({
    -- all options here
})
```

Config files for plugins that also define keybindings include a labelled keymaps section after setup:

```lua
-- =============================
-- [Plugin] Keymaps
-- =============================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
-- keymap definitions follow
```

## LSP Server Config Pattern

Each file in `neovim/lsp/` returns a plain Lua table (no `.setup()` call). The table is auto-loaded by `vim.lsp.enable()` in `neovim/lua/config/lsp.lua`:

```lua
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/<server-binary>', '--stdio' },
    root_markers = { 'relevant-config-files' },
    filetypes = { 'filetype' },
    settings = { ... },
}
```

Use `vim.fn.stdpath('data') .. '/mason/bin/<name>'` for the `cmd` field — not hardcoded paths, not `vim.fn.expand('~/')` (though `lua_ls.lua` uses expand, prefer stdpath for consistency with other servers).

## Keybinding Conventions

**Leader key:** `<Space>` (set in `neovim/lua/core/keymaps.lua`)

**Prefix groups (from `neovim/lua/config/which-key.lua`):**
| Prefix | Group |
|--------|-------|
| `<leader>a` | AI Tools |
| `<leader>b` | Buffers |
| `<leader>c` | Code Actions |
| `<leader>d` | Debug/Diagnostics |
| `<leader>e` | Explorer |
| `<leader>f` | Find (Telescope) |
| `<leader>g` | Git |
| `<leader>j` | Java |
| `<leader>l` | LSP |
| `<leader>n` | Tests (neotest) |
| `<leader>r` | Rename |
| `<leader>t` | Toggle |
| `<leader>w` | Workspace |

**Keymap registration pattern** — always pass a `desc` for which-key discoverability:
```lua
map('n', '<leader>xy', some_function, vim.tbl_extend('force', opts, {
    desc = 'Human-readable description'
}))
```

For buffer-local maps (set in `LspAttach` or `on_attach`):
```lua
vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', {
    buffer = ev.buf,
    desc = 'Go to definition',
})
```

**Navigation conventions:**
- `[x` / `]x` for backward/forward navigation through similar items (`[d`/`]d` diagnostics, `[c`/`]c` git hunks, `[n`/`]n` failed tests)
- `<S-h>` / `<S-l>` for previous/next buffer
- `<C-j>` / `<C-k>` for list navigation within pickers and completion menus

## Comment Style

Inline comments explain non-obvious behavior, not what the code does literally:

```lua
vim.opt.clipboard = 'unnamedplus'  -- sync clipboard between OS and Neovim

-- disable in ChatGPT input windows and prompts
-- Note: virtual_text handled by tiny-inline-diagnostic plugin
```

Section separators inside files use dashed lines with a label:
```lua
-- -----------------------------
-- buffers
-- -----------------------------
```

Commented-out options are kept in place as documentation of available choices (common in `catppuccin.lua` and `options.lua`).

## Indentation and Formatting

- **Lua:** 4-space indentation (enforced by `stylua` via conform.nvim; `neovim/lua/core/options.lua` sets `tabstop = 4`, `shiftwidth = 4`, `softtabstop = 4`)
- **Shell:** 4-space indentation, consistent with the Lua style
- No trailing whitespace; `listchars` shows trailing spaces as `·`

## Color Theme Consistency

Catppuccin Mocha is used across all tools. When configuring colors in Lua, always pull from the palette rather than hardcoding hex values:

```lua
local c = require('catppuccin.palettes').get_palette('mocha')
-- use c.base, c.mantle, c.surface0, c.text, c.overlay0, c.red, c.peach, etc.
```

Used in: `neovim/lua/config/bufferline.lua`

The theme name `'catppuccin-mocha'` is referenced by name in lualine: `theme = 'catppuccin-mocha'`.

## Module Requires

Plugin configs use the short module name without `.nvim` suffix:
```lua
require('neo-tree')       -- not require('nvim-neo-tree')
require('telescope')      -- not require('nvim-telescope/telescope.nvim')
require('gitsigns')
require('blink.cmp')
```

When accessing a plugin's sub-module, use dot notation:
```lua
local builtin = require('telescope/builtin')   -- note: / not . for telescope builtin
local actions = require('telescope.actions')
```

## Shell Script Conventions

**Shebang:** Always `#! /usr/bin/env bash` (space after `#!`) for utility scripts. Entry scripts use `#!/usr/bin/env bash` (no space).

**Function structure:**
- One function per logical task
- Functions check preconditions before acting (test `-f`, `-d`, `command -v`)
- Use `|| return 1` for non-fatal errors inside functions; `exit 1` only in `main()` for unrecoverable failures
- Print function from `utils/print.sh` before every major operation

**Utility sourcing pattern:**
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/print.sh"
source "$SCRIPT_DIR/utils/folders.sh"
```

**Symlink installation pattern** (used for every dotfile):
```bash
if ln -sf "$DOTFILES_DIR/<source>" "$HOME/<dest>"; then
    print_success "<thing> installed!"
else
    print_error "Failed to install <thing>!"
fi
```

---

*Convention analysis: 2026-05-16*
