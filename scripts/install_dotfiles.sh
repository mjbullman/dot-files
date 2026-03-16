#! /usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source utilities.
source "$SCRIPT_DIR/utils/print.sh"
source "$SCRIPT_DIR/utils/folders.sh"

# configuration
CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO="https://github.com/mjbullman/dot-files.git"

print_banner "Dot Files Installer"

function cd_dotfile_directory() {
    cd "$DOTFILES_DIR" || exit
}

function create_config_directory() {
    mkdir -p "$CONFIG_DIR" || return 1
}

function setup_repository() {
    print_banner "Setting Up Repository"

    if [[ -d "$DOTFILES_DIR" ]]; then
        print_info "Repository already exists, updating..."

        if git -C "$DOTFILES_DIR" pull origin main; then
            print_success "Repository updated successfully!"
        else
            print_error "Failed to update repository"
            return 1
        fi
    else
        print_info "Cloning repository..."

        if git clone "$DOTFILES_REPO" "$DOTFILES_DIR"; then
            print_success "Repository cloned successfully!"
        else
            print_error "Failed to clone repository"
            return 1
        fi
    fi
}

function clone_plugin() {
    local repo=$1
    local path=$2
    local name=$3

    if [ ! -d "$path" ]; then
        if git clone "$repo" "$path"; then
            print_success "$name Installed!"
        else
            print_error "Failed to Install $name!"
        fi
    else
        print_info "$name already installed."
    fi
}

function install_oh_my_zsh() {
    print_banner "Installing OhMyZsh Configurations"

    local custom_plugins="$HOME/.oh-my-zsh/custom/plugins"
    local zsh_completions_path="$custom_plugins/zsh-completions"
    local zsh_autosuggestions_path="$custom_plugins/zsh-autosuggestions"
    local zsh_syntax_highlighting_path="$custom_plugins/zsh-syntax-highlighting"
    local zsh_history_search_path="$custom_plugins/zsh-history-substring-search"

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        print_info "Oh My Zsh already installed."
    fi

    clone_plugin "https://github.com/zsh-users/zsh-completions.git" "$zsh_completions_path" "ZSH Completions"
    clone_plugin "https://github.com/zsh-users/zsh-autosuggestions.git" "$zsh_autosuggestions_path" "ZSH Autosuggestions"
    clone_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$zsh_syntax_highlighting_path" "ZSH Syntax Highlighting"
    clone_plugin "https://github.com/zsh-users/zsh-history-substring-search.git" "$zsh_history_search_path" "ZSH History Search"
}

function install_gitconfig() {
    if [[ -f "$DOTFILES_DIR/.gitconfig" ]]; then
        print_banner "Installing Git Configuration"

        if ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"; then
            print_success ".gitconfig installed!"
        else
            print_error "Failed to install .gitconfig!"
        fi
    fi
}

function install_gitconfig_local() {
    print_banner "Installing Local Git Configuration"

    if [[ -f "$HOME/.gitconfig.local" ]]; then
        print_info "~/.gitconfig.local already exists, skipping."
        return
    fi

    print_info "~/.gitconfig.local not found. Creating from user input..."
    read -rp "  Enter your git name:  " git_name
    read -rp "  Enter your git email: " git_email

    cat > "$HOME/.gitconfig.local" <<EOF
[user]
	name = $git_name
	email = $git_email
	signingKey = ""
EOF

    if [[ -f "$HOME/.gitconfig.local" ]]; then
        print_success "~/.gitconfig.local created!"
    else
        print_error "Failed to create ~/.gitconfig.local!"
    fi
}

function install_zsh_configs() {
    if [[ -f "$DOTFILES_DIR/.zshrc" ]]; then
        print_banner "Installing Zsh Configurations"

        if ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"; then
            print_success ".zshrc installed!"
        else
            print_error "Failed to install .zshrc!"
        fi
    fi

    if [[ -f "$DOTFILES_DIR/.zsh_aliases" ]]; then
        print_banner "Installing Zsh Aliases"

        if ln -sf "$DOTFILES_DIR/.zsh_aliases" "$HOME/.zsh_aliases"; then
            print_success ".zsh_aliases installed!"
        else
            print_error "Failed to install .zsh_aliases!"
        fi
    fi
}

function install_starship_config() {
    if [[ -f "$DOTFILES_DIR/starship.toml" ]]; then
        print_banner "Installing Starship Configuration"

        if ln -sf "$DOTFILES_DIR/starship.toml" "$CONFIG_DIR/starship.toml"; then
            print_success "starship.toml installed!"
        else
            print_error "Failed to install starship.toml!"
        fi
    fi
}

function install_ghostty_config() {
    if [[ -f "$DOTFILES_DIR/ghostty.config" ]]; then
        print_banner "Installing Ghostty Configuration"

        mkdir -p "$CONFIG_DIR/ghostty" || return 1

        if ln -sf "$DOTFILES_DIR/ghostty.config" "$CONFIG_DIR/ghostty/config"; then
            print_success "ghostty.config installed!"
        else
            print_error "Failed to install ghostty.config!"
        fi
    fi
}

function install_opencode_config() {
    if [[ -f "$DOTFILES_DIR/opencode.jsonc" ]]; then
        print_banner "Installing Opencode Configuration"

        mkdir -p "$CONFIG_DIR/opencode" || return 1

        if ln -sf "$DOTFILES_DIR/opencode.jsonc" "$CONFIG_DIR/opencode/opencode.jsonc"; then
            print_success "opencode.jsonc installed!"
        else
            print_error "Failed to install opencode.jsonc!"
        fi
    fi
}

function install_lazygit_config() {
    if [[ -f "$DOTFILES_DIR/config.yml" ]]; then
        print_banner "Installing Lazygit Configuration"

        mkdir -p "$CONFIG_DIR/lazygit" || return 1

        if ln -sf "$DOTFILES_DIR/config.yml" "$CONFIG_DIR/lazygit/config.yml"; then
            print_success "config.yml installed to ~/.config/lazygit/"
        else
            print_error "Failed to install config.yml to ~/.config/lazygit/!"
        fi

        local mac_lazygit_dir="$HOME/Library/Application Support/lazygit"

        mkdir -p "$mac_lazygit_dir" || return 1

        if ln -sf "$DOTFILES_DIR/config.yml" "$mac_lazygit_dir/config.yml"; then
            print_success "config.yml installed to ~/Library/Application Support/lazygit/"
        else
            print_error "Failed to install config.yml to ~/Library/Application Support/lazygit/!"
        fi
    fi
}

function install_tmux_config() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"

    if [[ -f "$DOTFILES_DIR/.tmux.conf" ]]; then
        print_banner "Installing Tmux Configuration"

        if ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"; then
            print_success ".tmux.conf installed!"
        else
            print_error "Failed to install .tmux.conf!"
        fi
    fi

    if [[ ! -d "$tpm_dir" ]]; then
        print_banner "Installing TPM (Tmux Plugin Manager)"

        if git clone https://github.com/tmux-plugins/tpm "$tpm_dir"; then
            print_success "TPM installed!"
        else
            print_error "Failed to install TPM!"
        fi
    else
        print_warning "TPM already installed!"
    fi
}

function install_neovim_config() {
    if [[ -d "$DOTFILES_DIR/neovim" ]]; then
        print_banner "Installing Neovim Configuration"

        # Remove existing real directory to prevent ln creating a nested symlink
        if [[ -d "$CONFIG_DIR/nvim" && ! -L "$CONFIG_DIR/nvim" ]]; then
            print_warning "$CONFIG_DIR/nvim exists as a real directory — removing before symlinking."
            rm -rf "$CONFIG_DIR/nvim"
        fi

        if ln -sf "$DOTFILES_DIR/neovim" "$CONFIG_DIR/nvim"; then
            print_success "Neovim configuration installed"
        else
            print_error "Failed to install Neovim configuration"
        fi
    fi
}

function install_neofetch_config() {
    local neofetch_dir="$CONFIG_DIR/neofetch"

    if [[ -f "$DOTFILES_DIR/neofetch.conf" ]]; then
        print_banner "Installing NeoFetch Configuration"

        mkdir -p "$neofetch_dir" || return 1

        if ln -sf "$DOTFILES_DIR/neofetch.conf" "$neofetch_dir/neofetch.conf"; then
            print_success "neofetch.conf installed"
        else
            print_error "Failed to install neofetch.conf"
        fi
    fi
}

function install_claude_config() {
    local claude_dir="$HOME/.claude"
    local claude_dotfiles_dir="$DOTFILES_DIR/claude"

    if [[ -d "$claude_dotfiles_dir" ]]; then
        print_banner "Installing Claude Code Configuration"

        mkdir -p "$claude_dir" || return 1

        if ln -sf "$claude_dotfiles_dir/settings.json" "$claude_dir/settings.json"; then
            print_success "Claude settings.json installed!"
        else
            print_error "Failed to install Claude settings.json!"
        fi

        if ln -sf "$claude_dotfiles_dir/statusline-command.sh" "$claude_dir/statusline-command.sh"; then
            print_success "Claude statusline-command.sh installed!"
        else
            print_error "Failed to install Claude statusline-command.sh!"
        fi
    fi
}

# main installation function.
main() {
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install git first."
        exit 1
    fi

    if ! create_config_directory; then
        print_error "Could not create: $CONFIG_DIR directory."
        exit 1
    fi

    if ! setup_repository; then
        print_error "Failed to setup repository."
        exit 1
    fi

    if ! cd_dotfile_directory; then
        print_error "Cannot access dot-files directory."
        exit 1
    fi

    install_oh_my_zsh
    install_gitconfig
    install_gitconfig_local
    install_zsh_configs
    install_ghostty_config
    install_starship_config
    install_tmux_config
    install_neovim_config
    install_neofetch_config
    install_opencode_config
    install_lazygit_config
    install_claude_config
    print_banner "Installation Complete!"
    print_success "Your dot-files have been installed successfully!"
}

# run main function
main "$@"
