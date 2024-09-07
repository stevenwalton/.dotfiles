#!/usr/bin/env bash

# $1 represents the file you want to check
movie_check() {
    echo "Checking file integrity for ${1}"
    # Show a progress bar
    pv "${1}" | ffmpeg -v error -i pipe:0  -map 0:1 -f null -
    if [[ "$?" -ne 0 ]];
    then
        echo -e "\033[1;31mERROR:\033[0m Something is wrong with video file: ${1}";
        exit 1
    fi
}

# $1 is the file you want to convert $2 is the location to 
toav1() {
    movie_check "${1}"
    echo "File starting with size:"
    du -h "${1}"
    # 23 is considered visually lossless for AV1
    declare -i CRF="${CRF:-30}"
    pv "${1}" | ffmpeg -y -v warning -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i pipe:0 -c:a copy -c:v av1_nvenc -rc-lookahead 64 -crf $CRF "${2}"
    movie_check "${2}"
    echo "Finished file is now:"
    du -h "${2}"
}

toav1_2pass() {
    ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i "${1}" -c:v av1_nvenc 
}
