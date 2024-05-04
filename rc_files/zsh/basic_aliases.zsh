####################
# Normal Aliases
# This should be second because we might replace some commands
####################

alias rm='rm -I' # prompt when >3 files being deleted
alias vi='vim'
alias ssh='ssh -YC'
# Tree replacement if don't have tree
if ! (_exists tree)
then
    alias tree='find . | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"'
fi
# Grep to have color, give line number, don't tell me it can't access restricted files (sudo), and don't process binary files (garbage output ):
alias grep='grep --color=always --no-messages --binary-files=without-match'

# Tmux doesn't like to recognize 256 colouring, so let's force it
# -u fixes backspace error thing
if (_exists tmux)
then
    alias tmux='tmux -2 -u'
fi

alias df='df -h'
alias log='git log --graph --oneline --decorate'

if (_exists kitty)
then
    alias ssh='kitty +kitten ssh'
fi
