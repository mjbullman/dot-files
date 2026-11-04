###############################################################################
#                           ~/.zprofile CONFIGURATION                          #
# --------------------------------------------------------------------------- #
# Author        : Martin Bullman                                              #
# Purpose       : Login shell environment setup — shared across platforms.   #
#                 Sources platform-specific profile for OS-level paths.      #
#                                                                             #
# Last Updated : 2026-06-13                                                   #
###############################################################################

# source platform-specific profile.
case "$(uname -s)" in
    Darwin) [[ -f ~/.zprofile_mac ]]   && source ~/.zprofile_mac ;;
    Linux)  [[ -f ~/.zprofile_linux ]] && source ~/.zprofile_linux ;;
esac

# user-local binaries (Claude Code, uv, hc) for every login shell, interactive or not.
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
