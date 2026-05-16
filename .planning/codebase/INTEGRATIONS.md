# External Integrations

**Analysis Date:** 2026-05-16

## AI Coding Assistants

**Codeium (active):**
- Purpose: Free AI inline completion in Neovim
- Plugin: `Exafunction/codeium.nvim`
- Config: `neovim/lua/plugins/codeium.lua`, `neovim/lua/config/codeium.lua`
- Integration: Blink.cmp source (`codeium.blink` module, score_offset 85)
- Auth: Handled by Codeium's own auth flow (no env var required)
- Chat: enabled via `enable_chat = true`

**Supermaven (active):**
- Purpose: AI inline completion (alternative/complement to Codeium)
- Plugin: `supermaven-inc/supermaven-nvim`
- Config: `neovim/lua/config/supermaven.lua`
- Integration: Standalone ghost text (not via Blink.cmp); accepts via `<C-l>`
- Auth: Supermaven account auth flow

**GitHub Copilot (installed, disabled at runtime by default):**
- Purpose: GitHub Copilot suggestions in Neovim
- Plugin: `github/copilot.vim`
- Config: `neovim/lua/config/copilot.lua`
- Auth: GitHub Copilot subscription; standard `copilot.vim` auth flow
- Toggle: `<leader>ac` (starts disabled: `vim.g.copilot_enabled = false`)
- Manual trigger: `<C-\>` in insert mode

**ChatGPT / OpenAI (installed, disabled — conflicts with Avante):**
- Purpose: ChatGPT interaction and code generation within Neovim
- Plugin: `jackMort/ChatGPT.nvim` (`enabled = false`)
- Config: `neovim/lua/config/chatgpt.lua`
- Auth: `OPENAI_API_KEY` environment variable (`api_key_cmd = 'echo $OPENAI_API_KEY'`)
- Model: `gpt-4o` for both chat and code editing
- Status: Disabled; plugin definition is retained but not loaded

**Opencode (standalone TUI):**
- Purpose: AI coding assistant TUI
- Config: `opencode.jsonc`
- Providers:
  - OpenAI (standard API)
  - Ollama — self-hosted LLM server at `http://192.168.1.180:11434/v1` (local network VM)
    - Default model: `ollama/qwen3-coder:480b-cloud`
    - Small model: `ollama/llama3.1:8b`
    - Additional models: GPT OSS 20B/120B, DeepSeek V3.1 671B, CodeLlama 7B, Gemini 3 Pro Preview, Kimi K2 1T

**Claude Code (standalone CLI):**
- Purpose: AI coding CLI (this tool)
- Config: `claude/settings.json` (symlinked to `~/.claude/settings.json`)
- Enabled plugins: `skill-creator@claude-plugins-official`, `code-review@claude-plugins-official`
- Theme: `dark-daltonized`
- GSD workflow hooks: Node.js scripts at `~/.claude/hooks/` triggered on SessionStart, PostToolUse, PreToolUse
- Node.js runtime: v24.15.0 via fnm

## LSP Server Management

**Mason.nvim:**
- Purpose: Install and manage LSP servers, formatters, and linters from within Neovim
- Plugin: `williamboman/mason.nvim` + `WhoIsSethDaniel/mason-tool-installer.nvim`
- Config: `neovim/lua/config/mason.lua`
- Install path: `~/.local/share/nvim/mason/`
- Auto-installs on startup (via mason-tool-installer)
- Managed tools:
  - LSP servers: `jdtls`, `vtsls`, `clangd`, `css-lsp`, `html-lsp`, `marksman`, `json-lsp`, `eslint-lsp`, `basedpyright`, `rust-analyzer`, `lua-language-server`, `vue-language-server`, `bash-language-server`
  - Formatters/linters: `ruff`, `black`, `stylua`, `prettier`
  - Java debug: `java-test`, `java-debug-adapter`
- Command: `:Mason` (lazy-loaded on command)
- Auto-update: disabled (`auto_update = false`)

## Version Control & Git Tools

**Lazygit:**
- Purpose: TUI git client
- Config: `config.yml` (symlinked to `~/.config/lazygit/config.yml` and `~/Library/Application Support/lazygit/config.yml`)
- Integration: Launched from Neovim via `Snacks.lazygit()` (`<leader>gg`)
- Theme: Catppuccin Mocha colors defined in `config.yml`
- Pager: `delta --features="catppuccin-mocha colorblind-diff" --paging=never`

**git-delta:**
- Purpose: Enhanced git diff pager with syntax highlighting
- Config: Embedded in `.gitconfig` under `[delta]` and `[delta "catppuccin-mocha"]`
- Features: `catppuccin-mocha colorblind-diff` (colorblind-safe diff colors)
- Set as default `core.pager` in `.gitconfig`

**git-lfs:**
- Purpose: Large file storage
- Config: Registered as filter in `.gitconfig` (`filter "lfs"` section)

**Gitsigns.nvim:**
- Purpose: In-buffer git hunk indicators and blame
- Plugin: `lewis6991/gitsigns.nvim`
- Config: `neovim/lua/config/gitsigns.lua`
- Integration: Statuscolumn git signs shown via `snacks.nvim` statuscolumn config

**GitHub CLI (gh) integration via Snacks.nvim:**
- Purpose: View GitHub issues and PRs from within Neovim
- Keymaps: `<leader>gi` (issues), `<leader>gp` (PRs)
- Module: `Snacks.gh.issue()` / `Snacks.gh.pr()`

## Shell Framework & Prompt

**Oh My Zsh:**
- Purpose: Zsh framework providing plugin management and completions
- Config: `.zshrc` (`export ZSH="$HOME/.oh-my-zsh"`)
- Install: `scripts/install_dotfiles.sh` → `install_oh_my_zsh()`
- Active plugins: `git`, `zsh-syntax-highlighting`, `zsh-autosuggestions`
- Also installed: `zsh-completions`, `zsh-history-substring-search`

**Starship:**
- Purpose: Cross-shell prompt with language version detection
- Config: `starship.toml` (symlinked to `~/.config/starship.toml`)
- Theme: Catppuccin Mocha palette (full palette defined inline)
- Language segments shown: C, Rust, Go, Node.js, PHP, Java, Kotlin, Haskell, Python, Conda, Docker

## Terminal Emulator

**Ghostty:**
- Purpose: Primary terminal emulator
- Config: `ghostty.config` (symlinked to `~/.config/ghostty/config`)
- Theme: Catppuccin Mocha
- Font: MesloLGS NF Regular (Nerd Font), size 15
- `allow-passthrough = on` enabled in Tmux to support image rendering (snacks.image)

## Terminal Multiplexer Plugins

**TPM (Tmux Plugin Manager):**
- Install path: `~/.tmux/plugins/tpm`
- Config: `.tmux.conf`
- Managed plugins:
  - `catppuccin/tmux#v2.1.3` — Catppuccin Mocha theme (pinned version)
  - `tmux-plugins/tmux-sensible` — sensible Tmux defaults
  - `christoomey/vim-tmux-navigator` — disabled (commented out)

## System Info

**Fastfetch:**
- Purpose: System info display on terminal startup
- Config: `neofetch.conf` (symlinked to `~/.config/neofetch/neofetch.conf`)
- Trigger: `[[ $SHLVL -eq 1 ]] && fastfetch` in `.zshrc` (runs only for top-level shell)

## Docker

**Docker CLI completions:**
- Enabled in `.zshrc` via `fpath=(/Users/martinbullman/.docker/completions $fpath)`
- No Docker Compose or container orchestration config present in this repo

## Debugging Adapters

**nvim-dap:**
- Purpose: Debug Adapter Protocol client for Neovim
- Config: `neovim/lua/config/debugging.lua`
- Language adapters:
  - Go: `nvim-dap-go` (auto-configured via `require('dap-go').setup()`)
  - Java: `java-debug-adapter` (installed via Mason, configured in `neovim/lua/config/jdtls.lua`)

## Testing Frameworks

**Neotest:**
- Purpose: Test runner integration in Neovim
- Config: `neovim/lua/config/neotest.lua`
- Adapters: `neotest-java` (only Java; loaded lazily on `ft = java`)

## Vue LSP Hybrid Mode

**vtsls + vue_ls (coupled integration):**
- Purpose: Full TypeScript + Vue template support
- `neovim/lsp/vtsls.lua`: Loads `@vue/typescript-plugin` from Mason's `vue-language-server` package path
  - Plugin path: `~/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin`
  - Critical setting: `enableForWorkspaceTypeScriptVersions = true` (required when `autoUseWorkspaceTsdk = true`)
- `neovim/lsp/vue_ls.lua`: Implements `tsserver/request` bridge in `on_init` to forward TypeScript requests to vtsls
- Required for: Nuxt 3 / Vue 3 projects; run `nuxt prepare` after cloning to generate `.nuxt/` types

## Environment Variables Referenced

| Variable | Used by | Purpose |
|----------|---------|---------|
| `OPENAI_API_KEY` | ChatGPT.nvim (`neovim/lua/config/chatgpt.lua`) | OpenAI API access (plugin disabled) |
| `ZSH` | `.zshrc` | Path to Oh My Zsh installation |
| `HOME` | `scripts/install_dotfiles.sh` | User home directory for symlink targets |

**Secrets location:** No secrets committed. `~/.gitconfig.local` (untracked) holds git user name/email. API keys expected as environment variables.

---

*Integration audit: 2026-05-16*
