#!/usr/bin/env bash
declare -i RC_LOOKAHEAD="${RC_LOOKAHEAD:-64}"
declare -i CRF="${CRF:-30}"


# $1 represents the file you want to check
# Make sure the movie is good before encoding
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

# Will print out _only_ the encoding. Such as (av1, hvec, h264, mpeg4, ...)
get_encoding() {
    ENCODING=$(find . -type f -exec bash -c 'ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "${0}"' {} \;)
    echo $ENCODING
}

# $1 is the file you want to convert $2 is the location to 
# Checks the original movie file first and will give info about size change
# We also check if the file is already AV1
toav1() {
    movie_check "${1}"
    echo "File starting with size:"
    du -h "${1}"
    if [[ $(get_encoding "${1}") == "av1" ]];
    then
        echo "Movie is already in AV1 encoding. Skipping ..."
    else
        # 23 is considered visually lossless for AV1
        pv "${1}" | ffmpeg -y -v warning -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i pipe:0 -c:a copy -c:v av1_nvenc -rc-lookahead $RC_LOOKAHEAD -crf $CRF "${2}"
        movie_check "${2}"
        echo "Finished file is now:"
        du -h "${2}"
    fi
}

toav1_2pass() {
    ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i "${1}" -c:v av1_nvenc 
}
