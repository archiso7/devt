# ============================================================================
# devt - Dev tool wrapper with tmux sessions
# ============================================================================
# A wrapper for Shopify's `dev` tool that creates tmux sessions
# Depends on gitc.zsh for shared utilities
# ============================================================================

# Source gitc.zsh for shared utilities
# Adjust this path based on where gitc.zsh is installed
if [[ -f "${0:A:h}/gitc/gitc.zsh" ]]; then
  source "${0:A:h}/gitc/gitc.zsh"
elif [[ -f "${HOME}/.config/zsh/gitc/gitc.zsh" ]]; then
  source "${HOME}/.config/zsh/gitc/gitc.zsh"
else
  echo "Error: gitc.zsh not found. devt requires gitc.zsh to be installed."
  return 1
fi

# ============================================================================
# devt command - tmux sessions with dev tool
# ============================================================================

devt() {
  # Validate arguments
  if [[ $# -lt 2 ]]; then
    echo "Usage: devt {cd|clone} <arguments>"
    return 1
  fi
  
  if [[ "$1" != "cd" && "$1" != "clone" ]]; then
    echo "Error: First argument must be 'cd' or 'clone'"
    return 1
  fi
  
  _tmux_session_with_command "dev" "$@"
}

devt-refresh-cache() {
  _refresh_github_cache "devdegree" "${HOME}/.cache/devt-devdegree-repos" 1000 "DevDegree"
}

_devt() {
  local -a subcommands
  subcommands=('cd:Change to a local repository' 'clone:Clone a repository')
  
  if [[ $CURRENT -eq 2 ]]; then
    _describe 'devt commands' subcommands
    return
  fi
  
  if [[ $CURRENT -eq 3 ]]; then
    case "$words[2]" in
      clone)
        local -a repos
        local cache_file="${HOME}/.cache/devt-devdegree-repos"
        repos=("${(@f)$(_fetch_github_repos "devdegree" "$cache_file")}")
        
        if [[ ${#repos[@]} -gt 0 ]]; then
          _describe 'DevDegree repositories' repos
        else
          _message "Install gh CLI and run: gh auth login"
        fi
        ;;
      cd)
        local devdegree_dir="${HOME}/src/github.com/DevDegree"
        if [[ -d "$devdegree_dir" ]]; then
          local -a local_repos
          local_repos=("${(@f)$(ls -1 $devdegree_dir 2>/dev/null)}")
          _describe 'local repositories' local_repos
        fi
        ;;
    esac
  fi
}

compdef _devt devt
