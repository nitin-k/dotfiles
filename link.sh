#!/bin/bash

# Creates a set of symbolic links for a dotfiles repository.
#
# This script is meant to be a "quick start":
#   1. Clone your dotfiles repository
#   2. Run `link.sh`

DOTFILES_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
SCRIPT_NAME="$(basename "$0")"

main() {
    cd "$DOTFILES_DIRECTORY"

    link_files $(list_files_to_symlink)
    setup_oh_my_zsh
    setup_vim_plug
}

# Tracked files to install under $HOME, excluding repo-only paths (see selesse/dotfiles create-symlinks).
list_files_to_symlink() {
    git -C "$DOTFILES_DIRECTORY" ls-files \
        | grep -Fxv -e README.md -e "$SCRIPT_NAME" -e nk.zsh-theme -e .gitignore \
            -e bootstrap -e bootstrap-bootstrap \
        | grep -v '^bootstrap-ubuntu/' \
        | while IFS= read -r file; do
            [[ -f "$DOTFILES_DIRECTORY/$file" ]] || continue
            printf '%s\n' "$file"
        done
}

link_files() {
    for file in "$@"; do
        home_file="$HOME/$file"
        if [[ -e "$home_file" ]]; then
            echo "Link for ${home_file} already exists - not doing anything"
        else
            home_file_directory="$(dirname "$home_file")"
            if ! [[ -d "$home_file_directory" ]]; then
                mkdir -p "$home_file_directory"
            fi
            ln -vs "$DOTFILES_DIRECTORY/$file" "$home_file"
        fi
    done
}

setup_oh_my_zsh() {
    install_oh_my_zsh
    setup_oh_my_zsh_theme
}

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "oh-my-zsh isn't installed - cloning from git"
        git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    fi
}

setup_oh_my_zsh_theme() {
    CUSTOM_THEME_DIR=$HOME/.oh-my-zsh/custom/themes

    if [ ! -L "$CUSTOM_THEME_DIR/nk.zsh-theme" ]; then
        mkdir -p "$CUSTOM_THEME_DIR"
        ln -vs "$DOTFILES_DIRECTORY/nk.zsh-theme" "$CUSTOM_THEME_DIR/nk.zsh-theme"
    fi
}

setup_vim_plug() {
    if ! [[ -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]]; then
        curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
}

main
