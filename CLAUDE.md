# CLAUDE.md

Guidance for Claude Code working in this repository.

## Repository Overview

Personal dotfiles for a macOS/Unix development environment: Neovim (lazy.nvim), Tmux, Zsh (Oh My Zsh + Starship), Ghostty. Everything uses the Catppuccin Mocha theme — match it when adding anything with colours.

Layout is discoverable by listing directories; only the non-obvious parts are documented below.

## Installation

`scripts/install_dotfiles.sh` detects macOS vs Linux, clones to `~/.dotfiles`, symlinks into `$HOME`, and installs dependencies (Oh My Zsh, TPM). Shared bash helpers live in `scripts/utils/`.

**Git config**: personal name/email live in `~/.gitconfig.local`, which is **not committed**. The tracked `.gitconfig` pulls it in via `[include]`. The install script creates it by prompting on first run — never hardcode identity into `.gitconfig`.

`scripts/dev_env.sh` creates or re-attaches the `MJBDotFiles` tmux session with nvim/claude/lazygit windows.

## Neovim

`neovim/` is symlinked to `~/.config/nvim`. Entry point `init.lua` → `lua/core/` (options, keymaps, lazy bootstrap) → lazy.nvim auto-discovers `lua/plugins/`.

**Where things go:**
- `lua/plugins/*.lua` — plugin specs. Anything non-trivial delegates to a matching `lua/config/*.lua`.
- `lua/disabled/{plugins,config}/` — parked plugins. lazy.nvim only scans `lua/plugins/`, so these are inert without needing `enabled = false`. Currently: `neotest` (a `neotest-java` adapter is already written), `auto-pairs`, `copilot`, `chatgpt`, `kulala` (REST client for `.http` files), `supermaven`.
- `neovim/lazy-lock.json` — pinned versions, and the **authoritative list of what is actually installed**. A plugin listed in a spec but absent here was never cloned.

**Verifying a change** — always do this rather than asserting it works:
```bash
nvim --headless +qa                                  # startup errors
nvim --headless "+lua print(vim.inspect(…))" +qa     # inspect runtime state
luac -p neovim/lua/config/<file>.lua                 # syntax only
```

### LSP

Built-in LSP (`vim.lsp.enable` / `vim.lsp.config`), **not** nvim-lspconfig. Global setup in `lua/config/lsp.lua` (Blink capabilities via `vim.lsp.config('*', …)`, diagnostics, inlay hints, LspAttach keymaps). Per-server files in `neovim/lsp/*.lua` are auto-loaded by name.

To add a server: add its name to the `vim.lsp.enable()` list in `lua/config/lsp.lua`, drop a `neovim/lsp/<server>.lua` if it needs options, install via `:Mason`. Keybindings apply automatically.

**Vue (hybrid mode)** — two servers cooperate; `vue_ls` does templates/styles, `vtsls` does TypeScript including `<script setup>`:
- `enableForWorkspaceTypeScriptVersions = true` is **required** when `autoUseWorkspaceTsdk = true`, or vtsls silently ignores the plugin `location` and TS can't find `@vue/typescript-plugin`.
- **Vue 2**: Mason's `vue-language-server` ships two conflicting `@vue/typescript-plugin` copies. Point at the **nested** one (`node_modules/@vue/language-server/node_modules/@vue/typescript-plugin`, v3.0.0 — still supports Vue 2), NOT the top-level v3.2.4, which dropped Vue 2 in v3.1.
- No `.git` in vtsls `root_markers` — it would anchor to the git root instead of the dir holding `tsconfig.json`.
- `vue_ls.lua` implements the `tsserver/request` bridge in `on_init`. Mandatory in v3; standalone mode was removed.
- Run `nuxt prepare` after pulling a Nuxt project to regenerate `.nuxt/` types.

**Java** is outside the `vim.lsp.enable()` list — `nvim-jdtls` (`lua/config/jdtls.lua`) starts on the `java` filetype and depends on `nvim-dap`.

### Completion

Blink.cmp (`lua/config/blink.lua`). Sources ranked by `score_offset`: LSP 120, lazydev 90, Codeium 85, snippets 50, path 10, buffer −20. To add a source, put it in `sources.default` and define the provider in `sources.providers`.

**Codeium is the only AI assistant, and it is popup-only.** Both `virtual_text.enable` and `enable_cmp_source` are `false`; it reaches the editor solely as a Blink source (`module = 'codeium.blink'`). There is deliberately **no inline ghost text** — short, LSP-shaped completions are preferred over multi-line blocks. Do not reinstate Supermaven to get "shorter" suggestions: its model emits long ghost text by design and has no length setting.

### snacks.nvim gotchas

**Most `enabled` flags do nothing.** Only 13 modules are gated by it (`snacks/init.lua`): `bigfile`, `image`, `quickfile`, `indent`, `explorer`, `words`, `dashboard`, `scroll`, `input`, `scope`, `picker` via event autocmds, plus `statuscolumn` and `notifier`. Every other module (`lazygit`, `gh`, `zen`, `scratch`, `profiler`, `rename`, `bufdelete`, …) is a lazy API loaded on first `Snacks.x()` call and **ignores the flag entirely** — so `enabled = false` does not disable it, and listing it in the config implies a switch that doesn't exist. To make one of those unavailable, don't bind it.

Animation is gated by `vim.g.snacks_animate`, not by the `animate` module flag.

### bufferline

`lua/config/bufferline.lua` hand-writes its highlight table from the Catppuccin palette, and `lua/config/catppuccin.lua` sets `bufferline = { enabled = false }` **on purpose**. These are deliberate custom colours — do not "simplify" by enabling the Catppuccin integration; it overwrites them.

Buffer cycling must use `BufferLineCycleNext` / `BufferLineCyclePrev`, not `:bnext` / `:bprevious`. Bufferline sorts with `sort_by = 'insert_after_current'`, so the plain commands jump somewhere other than the tab shown next to the current one.

## Tmux

`.tmux.conf`. Prefix is `Ctrl+A`; reload with `Ctrl+A` then `r`. Splits `|` and `-`, vim-style resize with `h/j/k/l`, base index 1, status bar at top.

- `allow-passthrough on` is **required** for snacks.image to draw through tmux into Ghostty.
- vim-tmux-navigator is **commented out**, so `Ctrl+h/j/k/l` does not cross between tmux panes and Neovim splits. The matching Neovim plugin sits in `neovim/lua/disabled/`.

## Zsh

`.zshrc` — Oh My Zsh (git, zsh-syntax-highlighting, zsh-autosuggestions), Starship prompt (`starship.toml`), aliases in `.zsh_aliases`.

- Fastfetch runs on startup only at `$SHLVL -eq 1`, so it stays out of nested shells.
- `.p10k.zsh` is legacy — Starship is the active prompt.
