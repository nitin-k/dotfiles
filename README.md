# Dotfiles

My personal dotfiles and configuration files.

## Features

- **Shell**: zsh with oh-my-zsh and custom theme
- **Editor**: Neovim with extensive configuration
- **Terminal**: tmux with session persistence
- **Package Management**: Homebrew, mise, and various language managers

## Quick Start

1. Clone this repository
2. Run `./bootstrap` to install and link all dotfiles
3. Restart your terminal

## Tmux Session Management

This dotfiles setup includes [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) for automatic session persistence.

### Setup

```bash
# Run the setup script
./bin/setup-tmux-resurrect

# Or use the alias
tmux-setup
```

### Usage

**Key Bindings:**
- `Ctrl-a + Ctrl-s`: Save tmux environment
- `Ctrl-a + Ctrl-r`: Restore tmux environment

**Aliases:**
- `tmux-save`: Save current session from outside tmux
- `tmux-restore`: Restore session from outside tmux
- `tmux-setup`: Run the setup script

### Features

- ✅ Saves all sessions, windows, panes and their order
- ✅ Restores current working directory for each pane
- ✅ Restores exact pane layouts within windows
- ✅ Saves and restores vim/neovim sessions
- ✅ Saves and restores pane contents
- ✅ Automatically saves every 15 minutes

### Configuration

- Session files are stored in: `~/.tmux/resurrect/`
- Vim sessions are automatically saved/restored
- Pane contents are captured and restored
- Additional programs (ssh, mysql, psql, vim, nvim) are restored

## Installation

See the main README for full installation instructions.
