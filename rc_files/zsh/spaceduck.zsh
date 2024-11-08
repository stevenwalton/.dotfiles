#################################
# Theming
#################################
#
# SpaceDuck Theme (for zsh-syntax-highlighting)
# Code licensed under the MIT license
# @author George Pickering <@bigpick>
# Paste this files contents inside your ~/.zshrc before you activate zsh-syntax-highlighting
main() {
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
    typeset -gA ZSH_HIGHLIGHT_STYLES
    #### Diffs
    #### Markup
    ### Classes
    ### Comments
    ZSH_HIGHLIGHT_STYLES[comment]='fg=#30365F'
    ### Constants
    ### Entitites
    ### Functions/methods
    ZSH_HIGHLIGHT_STYLES[alias]='fg=#5ccc96'
    ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#5ccc96'
    ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#5ccc96'
    ZSH_HIGHLIGHT_STYLES[function]='fg=#5ccc96'
    ZSH_HIGHLIGHT_STYLES[command]='fg=#5ccc96'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=#5ccc96,italic'
    ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#e39400,italic'
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#b3a1e6'
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#b3a1e6'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#b3a1e6'
    ### Keywords
    ### Built ins
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=#5ccc96'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#5ccc96'
    ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#5ccc96'
    ### Punctuation
    ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#ce6f8f'
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#ce6f8f'
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#ecf0c1'
    ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#ecf0c1'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#ce6f8f'
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#ce6f8f'
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#ce6f8f'
    ### Serializable / Configuration Languages
    ### Storage
    ### Strings
    ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#00a3cc'
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#00a3cc'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#00a3cc'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#e33400'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#00a3cc'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#e33400'
    ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#00a3cc'
    ### Variables
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#ecf0c1'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#e33400'
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#ecf0c1'
    ZSH_HIGHLIGHT_STYLES[assign]='fg=#ecf0c1'
    ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#ecf0c1'
    ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#ecf0c1'
    ### No category relevant in spec
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e33400'
    ZSH_HIGHLIGHT_STYLES[path]='fg=#ecf0c1'
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#ce6f8f'
    ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#ecf0c1'
    ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#ce6f8f'
    ZSH_HIGHLIGHT_STYLES[globbing]='fg=#ecf0c1'
    ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#b3a1e6'
    #ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
    #ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
    #ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
    #ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#e33400'
    ZSH_HIGHLIGHT_STYLES[redirection]='fg=#ecf0c1'
    ZSH_HIGHLIGHT_STYLES[arg0]='fg=#ecf0c1'
    ZSH_HIGHLIGHT_STYLES[default]='fg=#ecf0c1'
    #
    ZSH_HIGHLIGHT_STYLES[cursor]='standout'
}

main || echo "Couldn't load spaceduck theme"
