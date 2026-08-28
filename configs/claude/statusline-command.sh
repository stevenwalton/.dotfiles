#!/usr/bin/env bash
# Claude Code status line - inspired by Starship pastel powerline theme

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Colors matching Starship pastel powerline palette
PURPLE='\033[38;2;154;52;142m'
PINK='\033[38;2;218;98;125m'
PEACH='\033[38;2;252;161;125m'
BLUE='\033[38;2;134;187;216m'
TEAL='\033[38;2;6;150;154m'
NAVY='\033[38;2;51;101;138m'
RESET='\033[0m'
BOLD='\033[1m'

# Bedrock warning badge -- the statusline inherits Claude's env, so
# CLAUDE_CODE_USE_BEDROCK is set when this session is on billable Bedrock.
BEDROCK_BADGE=""
if [ -n "$CLAUDE_CODE_USE_BEDROCK" ]; then
    BEDROCK_BADGE='\033[48;2;200;40;40m\033[38;2;255;255;255m\033[1m BEDROCK \033[0m'
fi

# User and host
user=$(whoami)
host=$(hostname -s)

# Shorten path (truncate to last 3 components like Starship config)
short_path=$(echo "$cwd" | awk -F'/' '{
    n=NF;
    if (n <= 3) { print $0 }
    else { print ".../" $(n-2) "/" $(n-1) "/" $n }
}')
short_path="${short_path/#$HOME/~}"

# Git branch and status
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    git_status=$(git -C "$cwd" status --porcelain 2>/dev/null)
    dirty=""
    [ -n "$git_status" ] && dirty="*"
    git_info=" ${branch}${dirty}"
fi

# Context usage
ctx_info=""
if [ -n "$used_pct" ]; then
    ctx_int=${used_pct%.*}
    ctx_info=" ctx:${ctx_int}%%"
fi

# Time
time_str=$(date +%H:%M)

[ -n "$BEDROCK_BADGE" ] && printf "${BEDROCK_BADGE}"
printf "${PURPLE}${BOLD} ${user}@${host} ${RESET}"
printf "${PINK}${BOLD} ${short_path} ${RESET}"
[ -n "$git_info" ] && printf "${PEACH}${BOLD}${git_info} ${RESET}"
printf "${BLUE}${BOLD} ${model}${ctx_info} ${RESET}"
printf "${NAVY}${BOLD} ♥ ${time_str} ${RESET}"
printf "\n"
