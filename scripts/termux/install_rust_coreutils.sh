#!/data/data/com.termux/files/usr/bin/env bash
############################################################
# Downloads rust coreutils and then creates a directory
# you can place all those utils and call them as if they
# were the actual coreutils.
# The issue is that with these you need to call
# `coreutils ls -Ssh foo/dir` instead of `ls -Ssh foo/dir`
# So instead we'll create a mini script for each where 
# that script just appends `coreutils` and now we can 
# add them to our PATH and act as if we are just using
# coreutils normally
#
# I wrote this for termux but you can use it on any instance
# as long as you fix the shebang 
# (Both at the top of this file and the variable!)
#
# Rust coreutils Github:
# https://github.com/uutils/coreutils
#
# Author (of script): Steven Walton
# Contact: scripts@walton.mozmail.com
# License: MIT
############################################################


CARGO_DIR="${HOME%/}/.cargo/bin/"
RUST_UTILS_DIR="rustyUtils"
SHEBANG="${SHEBANG:-#!/data/data/com.termux/files/usr/bin/env bash}"

# Here's our microprogram (really an alias)
# Using the power of cat << EOF we'll dump this into a file
# where "${1}" is going to be the name of the program
make_program() {
    cat << HEADEREOF
${SHEBANG}

main() { 
    \${HOME%/}/.cargo/bin/coreutils "${1}" "\$@"
}

main "\$@"
HEADEREOF
}

main() {
    # Make sure we have installed coreutils
    if [[ ! -x "${CARGO_DIR%/}/coreutils" ]];
    then
        cargo install coreutils
    fi
    # Make our sub directory
    mkdir -p "${CARGO_DIR%/}/${RUST_UTILS_DIR%/}"
    # The help message lists all the coreutils but nor in a very nice way
    # So we'll read them out and make our program
    while read -r -d ',' line; 
    do 
        echo "Making: ${line}"
        touch "${CARGO_DIR%/}/${RUST_UTILS_DIR%/}/${line}"
        make_program "${line}" > "${CARGO_DIR%/}/${RUST_UTILS_DIR%/}/${line}"
        chmod +x "${CARGO_DIR%/}/${RUST_UTILS_DIR%/}/${line}"
        #rm "${CARGO_DIR%/}/${line}"
    done < <(coreutils | tail -n +7 | tr '\n' ' ' | tr -d ' ')

    echo "Please add ${CARGO_DIR%/}/${RUST_UTILS_DIR%/} to your path"
    echo -e "\texport PATH=\"\${HOME%/}/.cargo/bin/${RUST_UTILS_DIR%/}/:\${PATH}\""
}

main || exit 1
