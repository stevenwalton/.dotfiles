#!/usr/bin/env bash
# A collection of github functions
# Some of them will assume that you have gh installed
# Checkout Pull Requests with gh and pass through fzf
# Credit to [dcre](https://news.ycombinator.com/item?id=40500405)
ghpr() {
    gh pr list --limit 100 --json number,title,updatedAt,author --template \
        '{{range .}}{{tablerow .number .title .author.name (timeago .updatedAt)}}{{end}}' |
        fzf --height 25% --reverse |
        cut -f1 -d ' ' |
        xargs gh pr checkout
}

# Using fzf to checkout git branches
# Credit to [achristmascarl](https://news.ycombinator.com/item?id=40502649)
fzfcheckout() {
    git branch --sort=-committerdate | fzf | xargs -I{} git checkout {}
}
