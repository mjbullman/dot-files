# ⚙️ dot-files by Martin Bullman

Welcome to my personal collection of configuration files (dotfiles) for macOS and Unix-like environments. This setup is crafted for an efficient, aesthetic, and developer-friendly terminal experience.

## 🧰 Included Configurations

- **Tmux**: Terminal multiplexer with Catppuccin theme, mouse support, and custom keybindings.
- *(Others like Zsh, Neovim, etc. can be listed here if included in repo)*

---

## 🔲 TMUX CONFIG

### ✨ Features

- 📁 Full Catppuccin [Mocha] theme integration
- ⌨️ Prefix remapped to `Ctrl + A` (like GNU screen)
- 📐 Easier pane splitting and resizing
- 🖱️ Mouse support enabled
- 🕓 Right-aligned status bar with:
    - Current directory
    - Session name
    - System uptime
    - Date & time

### 📦 Plugins

Using [TPM](https://github.com/tmux-plugins/tpm):

- `catppuccin/tmux#v2.1.3`
- `tmux-plugins/tpm`

### 📄 Example `.tmux.conf`

> A full config is already included in this repo under `.tmux.conf`.  
> Quick preview:

```tmux
# Reload config
unbind r
bind r source-file ~/.tmux.conf \; display-message "Tmux config reloaded!"

# Set prefix to Ctrl+A
set-option -g prefix A
unbind C-b
bind A send-prefix

# Enable mouse support
set -g mouse on

# Theme and plugins
set -g @plugin 'catppuccin/tmux#v2.1.3'
set -g @plugin 'tmux-plugins/tpm'
set -g @catppuccin_flavour 'mocha'

# Status Bar
set -g status-right "#{E:@catppuccin_status_directory} #{E:@catppuccin_status_session} #{E:@catppuccin_status_uptime} #{E:@catppuccin_status_date_time}"

# Initialize TPM
run '~/.tmux/plugins/tpm/tpm'
