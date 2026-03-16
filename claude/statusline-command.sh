#!/usr/bin/env bash
###############################################################################
#                         CLAUDE CODE STATUS LINE                             #
# --------------------------------------------------------------------------- #
# Author       : Martin Bullman                                               #
# Purpose      : Status line for Claude Code, styled after Starship           #
#                Catppuccin Mocha theme.                                      #
###############################################################################

input=$(cat)

# Catppuccin Mocha palette (ANSI 24-bit color)
RED='\033[38;2;243;139;168m'
PEACH='\033[38;2;250;179;135m'
YELLOW='\033[38;2;249;226;175m'
GREEN='\033[38;2;166;227;161m'
SAPPHIRE='\033[38;2;116;199;236m'
LAVENDER='\033[38;2;180;190;254m'
CRUST='\033[38;2;17;17;27m'
RESET='\033[0m'
BOLD='\033[1m'

# Data from Claude Code
user=$(whoami)
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$dir" ] && dir=$(pwd)
dir_short=$(echo "$dir" | sed "s|$HOME|~|")

model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Git branch (skip optional locks for safety)
git_branch=""
if git -C "$dir" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$dir" symbolic-ref --short HEAD 2>/dev/null)
fi

# Build status line
printf "${RED}${BOLD} ${user} ${RESET}"
printf "${PEACH}${BOLD} ${dir_short} ${RESET}"

if [ -n "$git_branch" ]; then
  printf "${YELLOW}${BOLD}  ${git_branch} ${RESET}"
fi

if [ -n "$model" ]; then
  printf "${SAPPHIRE}${BOLD}  ${model} ${RESET}"
fi

if [ -n "$used" ]; then
  printf "${LAVENDER}${BOLD}  ${used}%% used ${RESET}"
fi

printf "\n"
