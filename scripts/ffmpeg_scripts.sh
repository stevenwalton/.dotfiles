#!/usr/bin/env bash
declare -i RC_LOOKAHEAD="${RC_LOOKAHEAD:-64}"
declare -i CRF="${CRF:-30}"
TMPDIR="/tmp/"

error_msg() {
    echo -e "\033[1;31mERROR:\033[0m ${0}" > /dev/stderr
}

# $1 represents the file you want to check
# Make sure the movie is good before encoding
movie_check() {
    echo "Checking file integrity for ${1}"
    ffmpeg_check() {
        ffmpeg -v error \
        -i pipe:0  \
        -map 0:1 \
        -f null -
        if [[ "$?" -ne 0 ]];
        then
            return 1
        fi
    }
    # Show a progress bar
    pv "${1}" | ffmpeg_check 
    if [[ "$?" -ne 0 ]];
    then
        # Echo error into stderr so we can see but return 1 for scripting 
        error_msg "Something is wrong with video file: ${1}" 
        return 1
    fi
    echo "Movie looks good!"
    return 0
}

# Will print out _only_ the encoding. Such as (av1, hvec, h264, mpeg4, ...)
get_encoding() {
    ENCODING=$(ffprobe -v error \
        -select_streams v:0 \
        -show_entries stream=codec_name \
        -of default=noprint_wrappers=1:nokey=1 \
        "${1}")
    if [[ "$?" -ne 0 ]];
    then
        error_msg "Failed to get encoding type"
        return 1
    fi
    echo $ENCODING
}

# $1 is the file you want to convert $2 is the location to 
# Checks the original movie file first and will give info about size change
# We also check if the file is already AV1
toav1() {
    movie_check "${1}"
    if [[ "$?" -eq 0 ]];
    then
        echo "File starting with size:"
        du -h "${1}"
        if [[ $(get_encoding "${1}") == "av1" ]];
        then
            error_msg "Movie is already in AV1 encoding. Skipping ..."
            return 1
        else
            # Set a temporary file that we'll output to in case the resultant is
            # bad so we don't overwrite the good movie
            tmp_file="${TMPDIR%/}/${2##*/}"
            # 23 is considered visually lossless for AV1
            pv "${1}" | \
                ffmpeg -y -v warning \
                -vsync 0 \
                -hwaccel cuda \
                -hwaccel_output_format cuda \
                -i pipe:0 \
                -c:a copy \
                -c:v av1_nvenc \
                -rc-lookahead $RC_LOOKAHEAD \
                -crf $CRF \
                "$tmp_file"
            movie_check "$tmp_file"
            if [[ "$?" -ne 0 ]];
            then
                error_msg "An error occurred (${1})"
                error_msg "\tA temporary output is located at ${tmp_file}"
                return 1
            else
                mv "$tmp_file" "${2}"
                echo "Finished file is now:"
                du -h "${2}"
                return 0
            fi
        fi
    else
        error_msg "An error occurred (${1}): Skipping..."
        return 1
    fi
    return 0
}

toav1_2pass() {
    ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i "${1}" -c:v av1_nvenc 
}
