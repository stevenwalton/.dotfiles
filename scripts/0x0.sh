#!/usr/bin/env bash
################################################################################
# Upload files to The Null Pointer
# https://0x0.st
#
# You can upload files and such with curl
# Author: Steven Walton
# LICENSE: MIT
# Contact: scripts@walton.mozmail.com
################################################################################

VERSION=0.1

usage() {
    cat << EOF
Upload files to The Null Pointer (https://0x0.st
EOF
}

# alias to pipe to https://0x0.st
# alias pipe_to_0x0="curl -F'file=@-' https://0x0.st"
# usage:
# echo "Hello Moto" | pipe_to_0x0
