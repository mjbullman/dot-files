# GEMINI.md: .dotfiles Analysis

## Project Overview

This repository contains a collection of personal dotfiles for creating a customized and efficient development environment. The configurations focus on enhancing the terminal and text editing experience, with a consistent [Catppuccin](https://github.com/catppuccin) theme across different tools.

The primary tools configured are:

*   **Shell:** Zsh (using [Oh My Zsh](https://ohmyz.sh/)) and Bash, with custom aliases for both Linux and macOS.
*   **Terminal Prompt:** [Starship](https://starship.rs/) is used for a highly customizable and informative prompt.
*   **Terminal Multiplexer:** [Tmux](https://github.com/tmux/tmux/wiki) is configured for session management, with keybindings inspired by GNU Screen.
*   **Terminal Emulator:** [Ghostty](https://ghostty.org/) settings are provided, including font and theme settings.
*   **Text Editor:** [Neovim](https://neovim.io/) has a modern Lua-based configuration, managed by the [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager.

## Installation and Usage

These dotfiles are meant to be placed in the user's home directory. As there is no automated installation script, the assumed method of use is to manually create symbolic links from the home directory to the files in this repository.

**TODO:** An installation script (e.g., `install.sh`) could be created to automate the process of creating these symbolic links, which would make setting up a new machine much faster.

Example of how to manually link a file:

```bash
ln -s /path/to/your/dotfiles/.zshrc ~/.zshrc
```

## Development Conventions

The most significant development convention is within the **Neovim configuration**, which is structured as follows:

*   `init.lua`: The main entry point. It sets up the `lazy.nvim` plugin manager.
*   `lua/core/`: This directory contains the core editor settings.
    *   `options.lua`: Sets fundamental Neovim options (line numbers, tabs, etc.).
    *   `keymaps.lua`: Defines custom keybindings.
*   `lua/plugins/`: Each file in this directory corresponds to a plugin or a group of related plugins, configured for `lazy.nvim`. This modular approach makes it easy to manage and update plugins.

## Key Configuration Files

*   `.zshrc`: The main configuration file for the Zsh shell. It sources Oh My Zsh and custom aliases.
*   `.bash_aliases` & `.zsh_aliases`: These files contain shell aliases to speed up common commands. They are separated for Bash and Zsh, and for Linux and macOS.
*   `starship.toml`: The configuration file for the Starship prompt, defining its appearance and the information it displays.
*   `.tmux.conf`: The configuration for the Tmux terminal multiplexer. It defines keybindings, plugins, and the status bar.
*   `ghostty.config`: Configuration for the Ghostty terminal emulator, including theme and font settings.
*   `neovim/`: The directory containing all Neovim configurations.
    *   `init.lua`: The entry point for the Neovim configuration.
    *   `lua/plugins/`: Directory where all the plugins are configured.
