<p align="center">
  <h1 align="center">⚙️ My Dotfiles</h1>
</p>

Welcome to my personal collection of dotfiles. These configurations are designed to create a consistent, beautiful, and efficient development environment across my machines. The setup is heavily themed with [Catppuccin](https://github.com/catppuccin) and tailored for a modern, terminal-centric workflow.

<p align="center">
  <img src="https://img.shields.io/badge/os-macOS-white?style=for-the-badge&logo=apple&logoColor=white" alt="macOS" />
  <img src="https://img.shields.io/badge/shell-Zsh-purple?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Zsh" />
  <img src="https://img.shields.io/badge/editor-Neovim-green?style=for-the-badge&logo=neovim&logoColor=white" alt="Neovim" />
  <img src="https://img.shields.io/badge/terminal-Ghostty-blue?style=for-the-badge" alt="Ghostty" />
  <img src="https://img.shields.io/badge/theme-Catppuccin-orange?style=for-the-badge" alt="Catppuccin" />
</p>

## 🚀 What's Inside?

This repository contains configurations for the following tools:

-   **Shell:** Zsh, powered by [Oh My Zsh](https://ohmyz.sh/), with custom aliases for both Linux and macOS.
-   **Prompt:** [Starship](https://starship.rs/) for a minimal, fast, and infinitely customizable prompt.
-   **Multiplexer:** [Tmux](https://github.com/tmux/tmux/wiki) for seamless session management, with keybindings inspired by GNU Screen.
-   **Editor:** [Neovim](https://neovim.io/) configured in Lua, with [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.
-   **Terminal:** [Ghostty](https://ghostty.org/) as the primary terminal emulator.
-   **Theme:** A consistent [Catppuccin](https://github.com/catppuccin) theme is applied across all tools.

## 🛠️ Installation

These dotfiles are intended to be placed in your home directory. The recommended way to install them is by creating symbolic links from your home directory to the files in this repository.

> **TODO:** An `install.sh` script will be added to automate this process.

**Manual Linking Example:**

```bash
# Backup your existing .zshrc
mv ~/.zshrc ~/.zshrc.bak

# Create a symbolic link
ln -s /path/to/your/dotfiles/.zshrc ~/.zshrc
```

Repeat this process for each configuration file you wish to use.

## ✨ Key Features

-   **Unified Look & Feel:** The Catppuccin theme provides a cohesive and beautiful aesthetic across all your tools.
-   **Modern Neovim Setup:** A fast, Lua-based Neovim configuration with a curated set of plugins for a full-featured IDE experience.
-   **Efficient Shell:** A powerful Zsh setup with useful aliases and a clean, informative prompt.
-   **Productive Tmux:** A `Ctrl+A` prefix, easy pane navigation, and a helpful status bar make for a great multiplexing experience.

## nvim Neovim Configuration

The Neovim setup is modular and easy to customize. It's structured as follows:

-   `init.lua`: The entry point that bootstraps `lazy.nvim`.
-   `lua/core/`: Core editor settings, including options and keymaps.
-   `lua/plugins/`: Each file in this directory defines a plugin or a set of related plugins for `lazy.nvim`.

This structure makes it simple to add, remove, or configure plugins without cluttering the main configuration file.

## 🎨 Theme

Everything is themed with [Catppuccin](https://github.com/catppuccin), specifically the `mocha` flavor. This provides a dark, elegant, and easy-on-the-eyes coding environment.

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.