# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configurations for a macOS/Unix development environment. The primary focus is on:
- **Neovim**: Modern Lua-based configuration using lazy.nvim plugin manager
- **Tmux**: Terminal multiplexer with Catppuccin theme
- **Zsh**: Shell configuration with Oh My Zsh, Starship prompt, and custom aliases
- **Ghostty**: Terminal emulator configuration
- **Starship**: Cross-shell prompt configuration

All tools use the Catppuccin Mocha theme for visual consistency.

## Installation Method

Files in this repository are meant to be symlinked to the user's home directory. There is no automated installation script - users manually create symbolic links.

Example:
```bash
mv ~/.zshrc ~/.zshrc.bak
ln -s /path/to/.dotfiles/.zshrc ~/.zshrc
```

## Neovim Configuration Architecture

The Neovim configuration follows a modular Lua-based structure:

**Entry Point**: `neovim/init.lua`
- Bootstraps the lazy.nvim plugin manager
- Loads core configuration from `lua/core/` (options, keymaps, lazy setup)
- Initializes plugins from `lua/plugins/` via lazy.nvim auto-discovery
- Configures global LSP settings and enables LSP servers

**Core Configuration** (`lua/core/`):
- `options.lua`: Fundamental editor settings (line numbers, tabs, clipboard, mouse support, split behavior)
- `keymaps.lua`: General keybindings not specific to plugins
- `lazy.lua`: lazy.nvim bootstrap and setup, global LSP configuration

**LSP Architecture**:
The configuration uses modern Neovim LSP (neovim/nvim-lspconfig):
- **Plugin definition** in `neovim/lua/plugins/lsp.lua`: Pseudo-plugin that loads on file events
- **LSP configuration** in `neovim/lua/config/lsp.lua`:
  - Sets capabilities from Blink.cmp for all servers
  - Configures root markers (`.git`)
  - Special configuration for `lua_ls` (Neovim development)
  - Enabled servers: `vtsls`, `jdtls`, `lua_ls`, `vue_ls`, `clangd`, `css_ls`, `rust_analyzer`, `html_ls`, `eslint_ls`, `basedpyright`, `jsonls`, `marksman`, `bashls`, `dockerls`
- **LSP keybindings**:
  - Uses LspAttach autocmd to set buffer-local keymaps when LSP attaches
  - Navigation: `gd` (definition), `gD` (declaration), `gi` (implementation), `gr` (references), `gt` (type definition)
  - Documentation: `K` (hover), `<C-k>` (signature help)
  - Actions: `<leader>ca` (code actions), `<leader>rn` (rename), `<leader>lf` (format)
  - Workspace: `<leader>wa/wr/wl` (add/remove/list workspace folders)
- **Mason** (`neovim/lua/plugins/mason.lua`): LSP server installer UI (cmd lazy-loaded)

**Completion System**:
- **Blink.cmp** (`neovim/lua/plugins/blink.lua`): Modern completion engine replacing nvim-cmp
  - Sources: LSP, Codeium, snippets, path, buffer
  - Special handling to disable in ChatGPT buffers
  - Custom keybindings: `<Tab>` (accept), `<C-j/k>` (next/prev), `<C-Space>` (show), `<C-y>` (select and accept)
  - Integrated with vim.snippet for snippet expansion
  - Configuration in `neovim/lua/config/blink.lua`

**AI Coding Assistants**:
- **Codeium** (`neovim/lua/plugins/codeium.lua`): Free AI completion integrated via Blink.cmp
- **GitHub Copilot Chat** (`neovim/lua/plugins/copilotchat.lua`): Interactive AI assistance
- **ChatGPT** (`neovim/lua/plugins/chatgpt.lua`): ChatGPT integration for code explanation and generation

**Plugin Management** (`lua/plugins/`):
Each file defines related plugins for lazy.nvim. Key plugins include:
- `telescope.lua`: Fuzzy finder with UI config in `lua/config/telescope.lua`
- `neotree.lua`: File explorer with config in `lua/config/neotree.lua`
- `catppuccin.lua`: Theme with config in `lua/config/catppuccin.lua`
- `bufferline.lua`: Buffer/tab bar with config in `lua/config/bufferline.lua`
- `treesitter.lua`: Syntax highlighting and code parsing
- `lualine.lua`: Status line
- `debugging.lua`: Debug adapter protocol support
- `tmuxnavigator.lua`: Seamless navigation between tmux panes and Neovim splits
- `which-key.lua`: Keybinding popup helper
- `dashboard.lua`: Start screen
- `comment.lua`: Comment toggling
- `nonels.lua`: none-ls for formatting/linting
- `inline-diagnostic.lua`: Inline diagnostic display

**Configuration Pattern**: Plugins defined in `lua/plugins/*.lua` often have corresponding detailed configuration files in `lua/config/*.lua`.

## Tmux Configuration

**File**: `.tmux.conf`

Key customizations:
- Prefix remapped to `Ctrl+A` (GNU Screen style)
- Mouse support enabled
- Catppuccin Mocha theme via TPM (Tmux Plugin Manager)
- vim-tmux-navigator plugin for seamless Neovim integration
- Custom pane splitting: `|` for horizontal, `-` for vertical
- Vim-style pane resizing: `h`, `l`, `j`, `k` with prefix
- Status bar positioned at top with directory, session, uptime, and datetime
- Base index starts at 1 for windows and panes

**Reload config**: `Ctrl+A` then `r`

## Zsh Configuration

**File**: `.zshrc`

Key features:
- Oh My Zsh framework with plugins: git, zsh-syntax-highlighting, zsh-autosuggestions
- Starship prompt (configured in `starship.toml`)
- Fastfetch runs on shell startup to display system info
- Custom aliases loaded from `.zsh_aliases`
- Docker CLI completions enabled

## File Organization

Configuration files in root:
- `.zshrc`, `.bash_aliases`, `.zsh_aliases`: Shell configurations
- `.tmux.conf`: Tmux configuration
- `starship.toml`: Starship prompt configuration
- `ghostty.config`: Ghostty terminal emulator settings
- `.p10k.zsh`: Powerlevel10k configuration (legacy, Starship is active)
- `neofetch.conf`: Neofetch system info display configuration

Neovim files:
- `neovim/init.lua`: Entry point
- `neovim/lua/core/`: Core editor settings
- `neovim/lua/plugins/`: Plugin definitions
- `neovim/lua/config/`: Detailed plugin configurations

## Common Development Patterns

**Modifying Neovim Configuration**:
1. Plugin definitions go in `lua/plugins/*.lua` using lazy.nvim return table format:
   ```lua
   return {
       "author/plugin-name",
       dependencies = { ... },
       config = function()
           require("config.pluginname")
       end,
   }
   ```
2. Complex plugin configs should be extracted to `lua/config/*.lua` and required from the plugin file
3. Core editor behavior goes in `lua/core/options.lua`
4. Keybindings can go in plugin files (plugin-specific) or `lua/core/keymaps.lua` (general)
5. All plugins are auto-loaded by lazy.nvim scanning the `lua/plugins/` directory

**Adding LSP Support for a New Language**:
1. Add the server name to the `vim.lsp.enable()` call in `neovim/lua/config/lsp.lua`
2. If the server needs special configuration, add it using `vim.lsp.config()` before the `vim.lsp.enable()` call
3. Install the language server via Mason (`:Mason` command in Neovim)
4. LSP keybindings are globally configured and apply to all servers automatically

**Adding Completion Sources to Blink.cmp**:
1. Add the source to the `sources.default` array in `neovim/lua/config/blink.lua`
2. Configure the provider in `sources.providers` with name, module, score_offset, and other settings
3. Higher `score_offset` values prioritize the source (LSP=100, Codeium=85, snippets=50, etc.)

**AI Assistant Integration**:
- Codeium provides inline completions via Blink.cmp (free, no API key needed)
- ChatGPT requires an API key stored in environment or config
- Copilot Chat requires GitHub Copilot subscription
- Blink.cmp is disabled in ChatGPT buffers to prevent interference (configured in `neovim/lua/config/blink.lua`)
