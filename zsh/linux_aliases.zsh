# Aliases specifically for linux machines 
# Nala: a better Apt
if (command -v nala &> /dev/null)
then
    alias apt='nala'
    # Secret trick to get this to work
    alias sudo='sudo '
fi

export CONDA_ROOT="${HOME}/.anaconda3"
alias open='xdg-open' 

# Add cuda to path if it's in the normal location
if [[ -d /usr/local/cuda ]]; then
    export PATH="/usr/local/cuda/bin:${PATH}"
    if [[ -d /usr/local/cuda/include ]]; then
        export LD_LIBRARY_PATH="/usr/local/cuda/include:${LD_LIBRARY_PATH}"
    fi
fi
