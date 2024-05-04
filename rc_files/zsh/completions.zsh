# Lines for autocompletion
autoload -Uz compinit # For compdef
compinit
# Completion notes
# - More *'s means 'more precise' (higher precidence)
# - %F{<color>} %f change foreground color
# - %K{<color>} %k change background color
# Some autocompletion
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ''
# case insensitive, partial word, and substring
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Enable approximate completion
zstyle ':completion:*' completer _complete _approximate
# Make "options" in green
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}==> %d <==%f'
# Set yellow color for approximate completions
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}==> %d (errors: %e) <==%f'
# Set messages in purple
zstyle ':completion:*:messages' format '%F{purple} ==> %d <==%f'
# Set warnings in red
zstyle ':completion:*:warnings' format '%F{red} ==> no matches found <==%f'
# Grouping
zstyle ':completion:*' group-name ''
# We want colors! All commands call the --color=auto 
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# Enable tab completion when flag has an equal sign
setopt magic_equal_subst

