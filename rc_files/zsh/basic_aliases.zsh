################################################################################
# Defined aliases for basic and standard commands
# This should be second because we might replace some of the core utils. Thus
# this file is separated to make that easier.
# So restrict this file to things more like core-utils 
################################################################################

alias rm='rm -I' # prompt when >3 files being deleted
alias vi='vim'
# alias ssh='ssh -YC'

# Tree replacement if don't have tree
if ! (_exists tree)
then
    alias tree='find . | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"'
fi
# Grep to have color, give line number, don't tell me it can't access restricted files (sudo), and don't process binary files (garbage output ):
# NOTE!!!!: This can on occasion cause the actual text of the output to change
# and fuck up piped commands. If that happens use `\grep` or `grep
# --color=never`.
# We might run into this bullshit: https://x.com/WaltonStevenj/status/1809378443655840238
alias grep='grep --color=always --no-messages --binary-files=without-match'


alias df='df -h'
alias log='git log --graph --oneline --decorate'

# really clear the screen
# Uses VT100 escape code \033 == \x18 == 27 == ESC (so this is <ESC>c
alias cls='printf "\033c"'
