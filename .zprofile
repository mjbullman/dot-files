###############################################################################
#                           ~/.zprofile CONFIGURATION                          #
# --------------------------------------------------------------------------- #
# Author        : Martin Bullman                                              #
# Purpose       : Login shell environment setup — shared across platforms.   #
#                 Sources platform-specific profile for OS-level paths.      #
#                                                                             #
# Last Updated : 2026-06-13                                                   #
###############################################################################

# fnm node version manager.
if command -v fnm &>/dev/null; then
    eval "$(fnm env --use-on-cd)"
fi

# source platform-specific profile.
case "$(uname -s)" in
    Darwin) [[ -f ~/.zprofile_mac ]]   && source ~/.zprofile_mac ;;
    Linux)  [[ -f ~/.zprofile_linux ]] && source ~/.zprofile_linux ;;
esac
