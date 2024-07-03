if [[ -d "${HOME%/}/.anaconda3" ]];
then
    export CONDA_ROOT="${HOME}/.anaconda3"
elif [[ -d "/opt/mambaforge" ]]
then
    export CONDA_ROOT="/opt/mambaforge"
fi
alias open='xdg-open' 
# Add cuda to path if it's in the normal location
if [[ -d /usr/local/cuda ]]; then
    export PATH="/usr/local/cuda/bin:${PATH}"
    if [[ -d /usr/local/cuda/include ]]; then
        export LD_LIBRARY_PATH="/usr/local/cuda/include:${LD_LIBRARY_PATH}"
    fi
fi
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

# find conda dir. Use first
export CONDA_ROOT="$(find "${HOME%/}/" -maxdepth 1 -type d -regextype posix-extended -regex '^/.*/\.([a]?.*onda\d?$|mamba$)') -print -quit"
CONDA_TYPE="$(find "${HOME%/}/" -maxdepth 1 -type d -regextype posix-extended -regex '^/.*/\.([a]?.*onda\d?$|mamba$)') -print -quit"
if [[ "${CONDA_TYPE##*/}" == .mamba ]];
then
    export MAMBA_EXE="${HOME%/}/.local/bin/micromamba";
    export MAMBA_ROOT_PREFIX="${HOME%/}/.mamba";
    __mamba_setup="$("${MAMBA_EXE}" shell hook --shell zsh --root-prefix "${MAMBA_ROOT_PREFIX}" 2> /dev/null)"
    if [[ $? -eq 0 ]];
    then
        eval "$__mamba_setup"
    else
        alias micromamba="${MAMBA_EXE}"
    fi
    alias conda='micromamba'
elif [[ "${CONDA_TYPE##*/}" == .conda || "${CONDA_TYPE##*/}" == .anaconda3 ]];
then
    export CONDA_ROOT="$CONDA_TYPE"
fi
unset CONDA_TYPE
# Make open work like osx
alias open='xdg-open' 
