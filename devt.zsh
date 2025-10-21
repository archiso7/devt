# ============================================================================
# devt - Dev tool wrapper with tmux sessions
# ============================================================================
# A wrapper for Shopify's `dev` tool that creates tmux sessions
# Depends on gitc.zsh for shared utilities
# ============================================================================

# Source gitc.zsh for shared utilities
# Adjust this path based on where gitc.zsh is installed
if [[ -f "${0:A:h}/../gitc/gitc.zsh" ]]; then
  source "${0:A:h}/../gitc/gitc.zsh"
elif [[ -f "${HOME}/.config/zsh/gitc/gitc.zsh" ]]; then
  source "${HOME}/.config/zsh/gitc/gitc.zsh"
else
  echo "Error: gitc.zsh not found. devt requires gitc.zsh to be installed."
  return 1
fi

# ============================================================================
# Configuration
# ============================================================================

# Default organization for devt
DEVT_ORG="${DEVT_ORG:-Shopify}"

# ============================================================================
# devt command - tmux sessions with dev tool
# ============================================================================

devt() {
  # Validate arguments
  if [[ $# -lt 2 ]]; then
    echo "Usage: devt {cd|clone} <repo-name|org/repo>"
    return 1
  fi
  
  if [[ "$1" != "cd" && "$1" != "clone" ]]; then
    echo "Error: First argument must be 'cd' or 'clone'"
    return 1
  fi
  
  local action="$1"
  local repo="$2"
  shift 2
  
  # If repo doesn't contain a slash, prepend DEVT_ORG
  if [[ "$action" == "clone" && "$repo" != */* ]]; then
    repo="${DEVT_ORG}/${repo}"
  fi
  
  _tmux_session_with_command "dev" "$action" "$repo" "$@"
}

devt-refresh-cache() {
  _refresh_github_cache "$DEVT_ORG" "${HOME}/.cache/gitc-${DEVT_ORG}-repos" 1000 "$DEVT_ORG"
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
        local current_word="${words[3]}"
        
        # Check if user is typing "org/" pattern for any org
        if [[ "$current_word" == */* ]]; then
          local typed_org="${current_word%%/*}"
          local typed_query="${current_word#*/}"
          
          # Use shared autocomplete function with full repo names (don't strip owner)
          _gitc_autocomplete_github_repos "$typed_org" "$typed_query" "$typed_org" false
        else
          # Default to DEVT_ORG, strip owner prefix for cleaner display
          _gitc_autocomplete_github_repos "$DEVT_ORG" "$current_word" "$DEVT_ORG" true
        fi
        ;;
      cd)
        # For cd, show local repos from the most common location
        local org_dir="${HOME}/src/github.com/${DEVT_ORG}"
        if [[ -d "$org_dir" ]]; then
          local -a local_repos
          local_repos=("${(@f)$(ls -1 $org_dir 2>/dev/null)}")
          _describe 'local repositories' local_repos
        fi
        ;;
    esac
  fi
}

compdef _devt devt

