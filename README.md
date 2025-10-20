# devt

A wrapper for Shopify's `dev` tool that creates tmux sessions for seamless development workflow.

## Features

- 🪟 **Tmux integration**: Automatically creates tmux sessions when running dev commands
- ⚡ **Auto-completion**: Tab completion for DevDegree repositories
- 📦 **Works with dev cd and dev clone**: Wraps both commands with tmux sessions
- 🔧 **Depends on gitc**: Uses gitc's shared utilities for GitHub integration

## Installation

### Prerequisites

**devt requires gitc to be installed first.**

### As submodules in your dotfiles

```bash
cd ~/.config/zsh

# Install gitc first (required dependency)
git submodule add <your-gitc-repo-url> gitc

# Then install devt
git submodule add <your-devt-repo-url> devt
```

### Standalone installation

```bash
# Install gitc first (required dependency)
git clone <your-gitc-repo-url> ~/.config/zsh/gitc

# Then install devt
git clone <your-devt-repo-url> ~/.config/zsh/devt
```

### Setup

Add to your `~/.zshrc`:

```zsh
# Load gitc first (required dependency)
source ~/.config/zsh/gitc/gitc.zsh

# Load devt
source ~/.config/zsh/devt/devt.zsh
```

## Usage

### Basic Usage

```bash
# Clone a DevDegree repo in a tmux session
devt clone devdegree/repo-name

# cd to a local repo in a tmux session
devt cd repo-name
```

### Auto-completion

```bash
# Tab completion for DevDegree repos
devt clone <TAB>

# Tab completion for local repos
devt cd <TAB>
```

**Tip**: For an even better completion experience with fuzzy search and preview, install [fzf-tab](https://github.com/Aloxaf/fzf-tab)!

### Cache Management

```bash
# Refresh DevDegree repo cache manually
devt-refresh-cache
```

Cache is automatically refreshed every hour.

## How It Works

When you run `devt clone` or `devt cd`:
1. A new tmux session is created with the repo name
2. The `dev clone` or `dev cd` command is executed inside the session
3. You're automatically attached to the session

This gives you a clean, named tmux session for each repo you're working on.

## Requirements

### Required
- `zsh`
- `tmux`
- `git`
- `gh` (GitHub CLI) - for auto-completion
- `dev` (Shopify's dev tool)
- **`gitc.zsh`** - Required dependency

### Recommended
- [fzf-tab](https://github.com/Aloxaf/fzf-tab) - For enhanced fuzzy-search completion with preview windows

## Configuration

devt uses gitc's shared utilities and configuration. See the [gitc README](../gitc/README.md) for configuration options.

## License

MIT

