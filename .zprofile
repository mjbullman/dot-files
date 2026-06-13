###############################################################################
#                           ~/.zprofile CONFIGURATION                         #
# --------------------------------------------------------------------------- #
# Author        : Martin Bullman                                              #
# Purpose       : Login shell environment setup — PATH, package managers,    #
#                 and language runtime configuration.                         #
#                                                                             #
# Features:                                                                   #
#   - Homebrew environment (hardcoded for fast startup)                       #
#   - fnm (Fast Node Manager) with auto-use on cd                            #
#   - Ruby and Python runtime PATH configuration                              #
#   - JetBrains Toolbox CLI scripts                                           #
#                                                                             #
# Note:                                                                       #
#   - Sourced once for login shells (new terminal tabs)                       #
#   - brew shellenv is hardcoded to avoid subprocess overhead                 #
#                                                                             #
# Last Updated : 2026-05-06                                                   #
###############################################################################

# homebrew settings.
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export MANPATH="/opt/homebrew/share/man:${MANPATH}"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

# JetBrains Toolbox CLI scripts.
export PATH="$PATH:/Users/martinbullman/Library/Application Support/JetBrains/Toolbox/scripts"

# fnm node version manager.
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

# ruby path settings.
if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=/opt/homebrew/lib/ruby/gems/4.0.0/bin:$PATH
fi


# python path settings.
PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
export PATH
