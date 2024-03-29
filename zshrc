# This will get called by files we source so place this here
# Just easier to check if commands exist
function _exists() {
    command -v "$1" &> /dev/null
}
# General Exports 
export ZSH_DIR=${HOME}/.dotfiles/zsh
export EDITOR="vim"
export PATH="${HOME}/.local/bin:${HOME}/.cargo/bin:$PATH"
# Shell like vim
# Keep this up here or the edit-command-line bindkey might mess up
set -o vi
## Lines for autocompletion
source ${ZSH_DIR}/completions.zsh
#
# Enable <C-x><C-e> editing style that bash has
# Credit: https://nuclearsquid.com/writings/edit-long-commands/
# Key this near top. It won't work if sheldon is above this
autoload -U edit-command-line
# Emacs style (<C-x><C-e>)
zle -N edit-command-line
# If not working with vim mode check that `set -o vi` is set above this line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
# Vi style (Uses visual to do)
#zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Sheldon uses TOML files.
# Soft linked: ~/.dotfiles/sheldon_plugins.toml ~/.config/sheldon/plugins.toml
# NOTE: Location sensitive. Check here if things aren't loading
if (_exists sheldon)
then
    eval "$(sheldon source)"
fi

# Bind keys for history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down\

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

#####################
# User configuration
#####################
# Starship theme
if (_exists starship)
then
    export STARSHIP_CONFIG="${HOME}/.dotfiles/starship.toml"
    eval "$(starship init zsh)"
fi

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd
#bindkey -v
# Enable history search with up/down keys
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

# Fixes tmux window renaming
DISABLE_AUTO_TITLE="true"

# Unset the autonaming for tmux
DISABLE_AUTO_TITLE="true"


#################################
# Aliases
# load machine specific aliases first as these might depend on /bin commands
#    that we will overwrite
# aliases.zsh has common tools that are not commonly found in /bin
# Then load basic_aliases which has things that will be in /bin. This is because
#    the aliases.zsh may change some /bin commands (like top=htop) and we want 
#    that first
#################################
if [[ $(uname) == "Linux" ]];
then
    source ${ZSH_DIR}/linux.zsh
elif [[ $(uname) == "Darwin" ]];
then
    source ${ZSH_DIR}/osx.zsh
else
    echo "Don't know machine $(uname). No machine specific aliases"
fi
source ${ZSH_DIR}/aliases.zsh
source ${ZSH_DIR}/basic_aliases.zsh

#################################
# Machine Specific Configurations
#################################
# -n is non-zero string, -z is true if no string
if [[ -n "${CONDA_ROOT}" ]];
then
    export CONDA_BIN=$CONDA_ROOT/bin
    export PATH=$CONDA_BIN:$PATH
    source $CONDA_BIN/activate
fi

function killssh()
{
    kill -9 $SSH_AGENT_PID
}
trap killssh 0

# For Nvidia
if [[ $(whoami) == "local-swalton" ]];
then
    conda activate py39
    source ~/Programming/tlt-pytorch/scripts/envsetup.sh
    alias tao="tao_pt --gpus all --env PYTHONPATH=/tao-pt --"
fi

# Spaceduck highlighting
source ${ZSH_DIR}/spaceduck.zsh
