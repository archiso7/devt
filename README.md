# devt

A wrapper for Shopify's `dev` tool that creates tmux sessions for seamless development workflow.

## Features

- 🪟 **Tmux integration** (optional): Automatically creates tmux sessions when running dev commands if tmux is available
- ⚡ **Smart auto-completion**: Intelligent search-based completion for large organizations (Shopify, etc.)
- 🎯 **Flexible repo format**: Use just `repo-name` for default org, or `org/repo` for any organization
- 📦 **Works with dev cd and dev clone**: Wraps both commands with optional tmux sessions
- 🔧 **Depends on gitc**: Uses gitc's shared utilities for GitHub integration and autocomplete

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
# Clone a repo from default org (Shopify) in a tmux session
devt clone my-app

# Clone from a specific org/user using org/repo format
devt clone kubernetes/kubectl
devt clone facebook/react

# cd to a local repo in a tmux session
devt cd my-app
```

### Auto-completion

```bash
# Smart incremental search for default org (Shopify) repos
devt clone <TAB>           # Prompts to type at least 2 characters
devt clone my<TAB>         # Shows Shopify repos matching "my"
devt clone my-app<TAB>     # Narrows down to "my-app" matches

# Search repos from any org using org/repo format
devt clone kubernetes/<TAB>      # Prompts to type search term
devt clone kubernetes/ku<TAB>    # Shows kubernetes repos matching "ku"
devt clone facebook/re<TAB>      # Shows facebook repos matching "re"

# Tab completion for local repos
devt cd <TAB>
```

**Smart Autocomplete**: `devt` uses **incremental search** for autocomplete powered by gitc's shared autocomplete function. It works with any organization, not just the default:

- **Type as you go**: Enter at least 2 characters and get instant search results
- **Lightning fast**: Uses GitHub's search API even for orgs with 10,000+ repos
- **Intelligent**: Automatically detects large orgs and switches to search mode
- **Cached**: Repo counts are cached for fast subsequent lookups (1 hour)
- **Flexible**: Works with default org or any `org/repo` format

**Tip**: For an even better completion experience with fuzzy search and preview, install [fzf-tab](https://github.com/Aloxaf/fzf-tab)!

### Cache Management

```bash
# Refresh Shopify repo cache manually (useful if you see stale data)
devt-refresh-cache
```

Cache is automatically refreshed every hour.

## How It Works

When you run `devt clone` or `devt cd`:
1. If tmux is available, a new tmux session is created with the repo name
2. The `dev clone` or `dev cd` command is executed (inside the session if tmux is available)
3. If tmux is available, you're automatically attached to the session

With tmux, this gives you a clean, named tmux session for each repo you're working on. Without tmux, it simply runs the dev command directly.

## Requirements

### Required
- `zsh`
- `git`
- `gh` (GitHub CLI) - for auto-completion
- `dev` (Shopify's dev tool)
- **`gitc.zsh`** - Required dependency

### Recommended
- `tmux` - For automatic session creation and management (gracefully degrades without it)
- [fzf-tab](https://github.com/Aloxaf/fzf-tab) - For enhanced fuzzy-search completion with preview windows

## Configuration

### devt-specific Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DEVT_ORG` | `Shopify` | GitHub organization to use for repo completion |

### Example Configuration

```zsh
# In your ~/.zshrc, set these BEFORE sourcing devt.zsh

# Use a different organization
export DEVT_ORG="MyCompany"

# Customize gitc autocomplete behavior (affects devt too)
export GITC_AUTOCOMPLETE_MAX_REPOS=500
export GITC_AUTOCOMPLETE_MIN_SEARCH_CHARS=2
export GITC_CACHE_TIME=3600

source ~/.config/zsh/gitc/gitc.zsh
source ~/.config/zsh/devt/devt.zsh
```

devt uses gitc's shared utilities and configuration for autocomplete. See the [gitc README](../gitc/README.md) for more configuration options.

## License

MIT

