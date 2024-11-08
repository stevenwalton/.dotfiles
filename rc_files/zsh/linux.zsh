
function config_general() {
    # Make open command work like on mac
    alias open='xdg-open' 
}

function config_cuda() {
    # Add cuda to path if it's in the normal location
    if [[ -d /usr/local/cuda || -d /opt/cuda ]]; then
        if [[ -d /usr/local/cuda ]];
        then
            CUDA_PATH="/usr/local/cuda"
        else
            CUDA_PATH="/opt/cuda"
        fi
        export PATH="${CUDA_PATH%/}/bin:${PATH}"
        if [[ -d "${CUDA_PATH%/}/include" ]]; then
            export LD_LIBRARY_PATH="${CUDA_PATH%/}/include:${LD_LIBRARY_PATH}"
        fi
    fi
}

# If we have an Nvidia card and Steam let's make sure we have the correct
# environment variables to ensure that we're correctly loading and can support
# 4k@60fps and raytracing
function config_nvidia() {
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
}

function config_pkgmgr() {
    # Aliases specifically for (Ubuntu) linux machines 
    # Nala: a better Apt
    if (_exists nala)
    then
        alias apt='nala'
        # Secret trick to get this to work
        alias sudo='sudo '
    fi
}

main() {
    config_general || echo "General linux config failed"
    config_cuda || echo "Cuda config failed"
    config_nvidia || echo "Nvidia configurations failed"
    config_pkgmgr || echo "Package manager not conifgured properly"

}

main || echo "Couldn't load linux configs"
