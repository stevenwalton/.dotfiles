if [[ -d "/opt/mambaforge" ]]
then
    export CONDA_ROOT="/opt/mambaforge"
elif [[ -d "${HOME%/}/.anaconda3" ]];
then
    export CONDA_ROOT="${HOME}/.anaconda3"
fi
alias open='xdg-open' 
# Add cuda to path if it's in the normal location
if [[ -d /usr/local/cuda ]]; then
    export PATH="/usr/local/cuda/bin:${PATH}"
    if [[ -d /usr/local/cuda/include ]]; then
        export LD_LIBRARY_PATH="/usr/local/cuda/include:${LD_LIBRARY_PATH}"
    fi
fi

# If we have an Nvidia card and Steam let's make sure we have the correct
# environment variables to ensure that we're correctly loading and can support
# 4k@60fps and raytracing
if (lspci | grep -i nvidia &> /dev/null) && (_exists steam);
then
    # Enable ray tracing
    # (https://www.reddit.com/r/linux_gaming/comments/zgrktp/raytracing_on_linux/)
    # demask nVidia GPUs as they are by default reported as AMD GPU
    export PROTON_HIDE_NVIDIA_GPU=0
    # Enable the latest NVAPI to report proper nVidia GPU driver
    # versions and GPU capabilities to games. 
    export PROTON_ENABLE_NVAPI=1
    # Over the air NGX update so nVidia can ship the latest NGX version
    # to games running through Proton directly. 
    export PROTON_ENABLE_NGX_UPDATER=1
    # Enable DirectX Raytracing Feature level 1.0 and 1.1 for games
    # running via DirectX 12 which is translated by VKD3D (Vulkan Direct
    # 3D). 
    export VKD3D_CONFIG=dxr,dxr11
    #alias steam='steam -bigpicture --intro-skip --launcher-skip-skipStartScreen'
    alias steam='steam --intro-skip --launcher-skip-skipStartScreen'
fi
#
# Aliases specifically for linux machines 
# Nala: a better Apt
if (_exists nala)
then
    alias apt='nala'
    # Secret trick to get this to work
    alias sudo='sudo '
fi


# Conda might be in a number of places and be configured in different ways. So
# let's try this complicated bs to figure out what we have and where it is.
# We'll prefer builds on our local directory as opposed to /opt
# We should clean this up better but I'll do it later (i.e. when I need it)
#if [[ $(find "${HOME%/}/" -maxdepth 1 -type d -regextype posix-extended -regex '^/.*/\.([a]?.*onda\d?$|mamba$)' -print -quit) ]];
#then
#    echo "We got into where we shouldn't"
#    echo "$(find "${HOME%/}/" -maxdepth 1 -type d -regextype posix-extended -regex '^/.*/\.([a]?.*onda\d?$|mamba$)' -print -quit)"
#    export CONDA_ROOT="$(find "${HOME%/}/" -maxdepth 1 -type d -regextype posix-extended -regex '^/.*/\.([a]?.*onda\d?$|mamba$)') -print -quit"
#    CONDA_TYPE="$(find "${HOME%/}/" -maxdepth 1 -type d -regextype posix-extended -regex '^/.*/\.([a]?.*onda\d?$|mamba$)') -print -quit"
#    if [[ "${CONDA_TYPE##*/}" == .mamba ]];
#    then
#        export MAMBA_EXE="${HOME%/}/.local/bin/micromamba";
#        export MAMBA_ROOT_PREFIX="${HOME%/}/.mamba";
#        __mamba_setup="$("${MAMBA_EXE}" shell hook --shell zsh --root-prefix "${MAMBA_ROOT_PREFIX}" 2> /dev/null)"
#        if [[ $? -eq 0 ]];
#        then
#            eval "$__mamba_setup"
#        else
#            alias micromamba="${MAMBA_EXE}"
#        fi
#        alias conda='micromamba'
#    elif [[ "${CONDA_TYPE##*/}" == .conda || "${CONDA_TYPE##*/}" == .anaconda3 ]];
#    then
#        export CONDA_ROOT="$CONDA_TYPE"
#    fi
#    unset CONDA_TYPE
if [[ $(find /opt -type d -name "mambaforge") ]];
then
    __conda_setup="$('/opt/mambaforge/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/mambaforge/etc/profile.d/conda.sh" ]; then
            . "/opt/mambaforge/etc/profile.d/conda.sh"
        else
            export PATH="/opt/mambaforge/bin:$PATH"
        fi
    fi
    unset __conda_setup

    if [ -f "/opt/mambaforge/etc/profile.d/mamba.sh" ]; then
        . "/opt/mambaforge/etc/profile.d/mamba.sh"
    fi
    # <<< conda initialize <<<
fi

alias open='xdg-open' 

# For Nvidia Colossus machines
#if [[ $(whoami) == "local-swalton" ]];
#then
#    conda activate py39
#    source "${HOME%/}/Programming/tlt-pytorch/scripts/envsetup.sh"
#    alias tao="tao_pt --gpus all --env PYTHONPATH=/tao-pt --"
#fi
