#!/usr/bin/env bash
################################################################################
# Functions to help with ffmpeg tasks.
# These should not be expected to be "one-size-fits-all type of functions, but
# so far they seem to work pretty well. 
# I've tried making a lot of comments to help with when this is not the case,
# and so that it is at least easy to echo the commands and then modify them.
# Values can be overwritten by providing environment variables to make these
# easier to incorporate into scripts or to reduce flags when repeating
# processes.
#
# Author: Steven Walton
# LICENSE: MIT
# Contact: scripts@walton.mozmail.com
#
# Additional Resources:
# #####################
# - Main ffmpeg docs: 
#       https://www.ffmpeg.org/ffmpeg-codecs.html
# - FFmpeg By Example:
#       https://ffmpegbyexample.com/
#       https://news.ycombinator.com/item?id=42695547
# - Nvidia Docs (Change 12.2 to latest CUDA version)
#       https://docs.nvidia.com/video-technologies/video-codec-sdk/12.2/ffmpeg-with-nvidia-gpu/index.html#performance-evaluation-and-optimization
#
# You can see the available commands for each encoder using the following
# command (av1_nvenc is an example)
#   ffmpeg -hide_banner -h encoder=av1_nvenc | bat --language=help
#
# To effectively use this script you probably want to run it in a loop in a
# directory with shows or movies.
# I don't include that feature here because when doing shows you probably are
# wanting to rename them.
# Here's an example of how you might want to use this in a loop
#
# while IFS= LC_ALL=C read -r -d '' file;
# do
#   new_file=$(echo "${file:2}" | sed -E "s/(.* - S01E[01][0-9] - .*) \(.*/\1.mkv/g")
#   </dev/null encode_av1 "${file}" "new_location/${new_file}"
# done < <(find . -maxdepth 1 -type f '*.mkv' -print0)
#
# We use the `</dev/null` prefix to help make sure that nothing else is going
# into the command.
# You might get errors without it
#
# Also a helpful tip:
# ffmpeg -i "some_movie.mp4" -c copy -c:s ssa "some_movie.mkv"
################################################################################
# Recommended 10-20 frames for optimal quality benefits
# More requires more memory (we don't care....)
# Use >= number of B frames + 1 to best utilize CPU
declare -i RC_LOOKAHEAD="${RC_LOOKAHEAD:+32}"
# For AV1 23 is considered visually lossless, but we'll use 20 because this
# feels a bit better in my experience
# For H264 and H265 (HEVC) this is 17-18
# https://trac.ffmpeg.org/wiki/Encode/H.264#crf
declare -Ar CRF_DEFAULTS=(
    [AV1]=20
    [h264]=17
    [h265]=17
)
# Will default to a _visually_ lossless value based on the encoding choice
declare -i CRF=${CRF}
declare TMPDIR="${TMPDIR:-/tmp/}"
# AV1 is currently one of the best encodings, so this is a good default
declare FORMAT="${FORMAT:-av1}"
declare BUFSIZE="2M"
# For using the `pv` command, which will show a progress bar
declare -i USE_PV=${USE_PV:-0}
declare -i HAS_PV=
if [[ ! $(command -v pv) ]];
then
    [[ $USE_PV -eq 1 ]] && echo "pv not installed. Falling back..."
    USE_PV=0
    HAS_PV=0
else
    HAS_PV=1
    USE_PV=1
fi
# Use hardware acceleration?
declare -i USE_CUDA=1
declare VIDEO_CODEC='av1_nvenc'
declare AOPTS=

### Adaptive Quantization settings
# These seem to work in the nvidia AV1 encoding 
# Spatial AQ
# Based on spatial characteristics, accounting for fact that low
# complexity regions show quality differences more easily (extra 
# bits to flat regions)
declare -i USE_SAQ=1
# Spatial AQ can range from 1 to 15
declare -i SAQ_STRENGTH=8
# Temporal AQ
# Extra bits to low motion frames so they become better reference frames
# Most benefit when most of frame has little or no motion but 
# high spatial detail
declare -i USE_TAQ=1
# For nvidia docs see (might need to change codec url. Just number)
# https://docs.nvidia.com/video-technologies/video-codec-sdk/12.2/ffmpeg-with-nvidia-gpu/index.html
#

# String format: use for EOL in eval type commands for clearer
# reading when echo debugging
declare sfmt='\\\n\t'
# debug variable
declare -i DEBUG=${DEBUG:-0}
declare INPUT_FILE=
declare OUTPUT_FILE=

error_msg() {
    echo -e "\033[1;31mERROR:\033[0m ${1}" > /dev/stderr
}

# $1 represents the file you want to check
# Make sure the movie is good before encoding
movie_check() {
    echo "Checking file integrity for ${1}"
    ffmpeg_check() {
        ffmpeg \
        -v error \
        -i pipe:0  \
        -map 0:1 \
        -f null -
        #&> /dev/null
        # uncomment redirect for quite (add option later)
        exit_status=$(echo "$?")
        ## We do this here because pv might get errors
        if [[ "${exit_status}" -ne 0 ]];
        then
            echo "${exit_status}"
            return 1
        fi
        echo 0
    }
    # Show a progress bar
    exit_status="$(pv "${1}" | ffmpeg_check)"
    if [[ "${exit_status}" -ne 0 ]];
    then
        # Echo error into stderr so we can see but return 1 for scripting 
        error_msg "(${exit_status}) Something is wrong with video file: ${1}" 
        return 1
    fi
    echo "Movie looks good!"
    return 0
}

# Prints ffprobe info where values are comma separated 
# (easy for sed)
ffprobe_info() {
    # To print one entry per line do this
    # -of default=noprint_wrappers=1:nokey=1 \
    FFINFO=$(ffprobe -v error \
        -select_streams v:0 \
        -show_entries stream="${1}" \
        -analyzeduration 5000M \
        -probesize 5000M \
        -of csv=p=0 \
        "${2}")
    if [[ "$?" -ne 0 ]];
    then
        error_msg "Failed to get ${1}"
    fi
    echo "$FFINFO"
}

# Get video resolution
ffprobe_resolution() {
    RESOLUTION=$(ffprobe_info "width,height" "${1}")
    echo "$RESOLUTION"
}

# Will print out _only_ the encoding. Such as (av1, hvec, h264, mpeg4, ...)
ffprobe_encoding() {
    ENCODING=$(ffprobe_info "codec_name" "${1}")
    echo "$ENCODING"
}

# Long version of encoding name
ffprobe_encoding_long() {
    ENCODING=$(ffprobe_info "codec_long_name" "${1}")
    echo "$ENCODING"
}

# Get video runtime
ffprobe_duration() {
    DURATION=$(ffprobe -v error \
        -select_streams v:0 \
        -show_entries format=duration \
        -of csv=p=0 \
        "${1}")
    if [[ "$?" -ne 0 ]];
    then
        error_msg "Failed to get ${1}"
    fi
    declare -i NUM=$(echo "$DURATION" | cut -d '.' -f1)
    declare -i MS=$(echo "$DURATION" | cut -d '.' -f2)
    declare -i HR="$(( NUM / 3600 ))"
    declare -i MIN="$(( $(( NUM  - $(( $HR * 3600 )) )) / 60 ))"
    declare -i SEC="$(( NUM - $(( MIN * 60 )) ))"
    echo "${HR}:${MIN}:${SEC}.${MS}"
}

# Some basic information about a video
# codec name, codec type, resolution, pixel format, aspect ratio, runtime
ffprobe_basic() {
    FINFO=$(ffprobe_info "codec_long_name,codec_type,width,height,pix_fmt,display_aspect_ratio" "${1}")
    CODEC="$(echo "${FINFO}" | cut -d "," -f1)"
    CTYPE="$(echo "${FINFO}" | cut -d "," -f2)"
    RESOLUTION="$(echo "${FINFO}" | cut -d "," -f3-4)"
    PIXFMT="$(echo "${FINFO}" | cut -d "," -f5)"
    ASPECT_RATIO="$(echo "${FINFO}" | cut -d "," -f6)"
    echo "CODEC:\t\t${CODEC}"
    echo "TYPE:\t\t${CTYPE}"
    echo "RESOLUTION:\t${RESOLUTION}"
    echo "PIXEL FORMAT:\t${PIXFMT}"
    echo "ASPECT RATIO:\t${ASPECT_RATIO}"
    echo "DURATION: \t$(ffprobe_duration "${1}")"
}

# Helper function to encode a video
ffencode() {
    declare encode_command
    if [[ $HAS_PV -eq 1 && "$USE_PV" -eq 1 ]];
    then
        encode_command+="pv \"${1}\" | ${sfmt}"
    fi
    encode_command+="ffmpeg -y -v warning -nostdin ${sfmt}"
    if [[ "$USE_CUDA" -eq 1 ]];
    then
        encode_command+="-hwaccel cuda ${sfmt}-hwaccel_output_format cuda ${sfmt}"
    fi
    if [[ $HAS_PV -eq 1 && "$USE_PV" -eq 1 ]];
    then
        encode_command+="-i pipe:0 ${sfmt}"
    else
        encode_command+="-i \"${1}\" ${sfmt}"
    fi
    encode_command+="-c:a copy ${sfmt}-c:v ${VIDEO_CODEC} ${sfmt}"
    encode_command+="-bufsize ${BUFSIZE} ${sfmt}"
    if [[ ${SAQ_STRENGTH} -gt 0 && $USE_SAQ -eq 1 ]];
    then
        if [[ ${SAQ_STRENGTH} -gt 15 || ${SAQ_STRENGTH} -lt 0 ]];
        then
            echo "Spatial AQ Strength limited to (1-15)"
            exit 1
        fi
        encode_command+="-spatial-aq 1 -aq-strength ${SAQ_STRENGTH} ${sfmt}"
    fi
    if [[ $USE_TAQ -eq 1 ]];
    then
        encode_command+="-temporal_aq 1 ${sfmt}"
    fi
    if [[ ${RC_LOOKAHEAD} -gt 0 ]];
    then
        encode_command+="-rc-lookahead ${RC_LOOKAHEAD} ${sfmt}"
    fi
    encode_command+="-crf ${CRF} ${sfmt}"
    if [[ $AOPTS != "" ]];
    then
        encode_command+="${AOPTS} ${sfmt}"
    fi
    encode_command+="\"${2}\""
    if [[ $DEBUG -gt 0 ]];
    then
        echo "DEBUG LEVEL ${DEBUG}"
        echo "Running:"
        echo -e "$encode_command"
        echo -e "TMPDIR: ${TMPDIR}\n"
    fi
    eval "$(echo -e "${encode_command}")"
    cleanup
}

# AV1
# https://trac.ffmpeg.org/wiki/Encode/AV1
encode_av1() {
    #echo "Into encode with ${@}"
    parse_args "$@"
    if [[ $CRF -le 0 ]];
    then
        CRF=${CRF_DEFAULTS[AV1]}
    fi
    #CRF=${CRF:-20}
    if [[ $USE_CUDA -eq 1 ]]; 
    then
        VIDEO_CODEC="av1_nvenc"
    else
        VIDEO_CODEC="libaom-av1"
    fi
    AOPTS="-preset p6 -lookahead_level 2 -highbitdepth 1 -surfaces 64"
    ffencode "${INPUT_FILE}" "${OUTPUT_FILE}"
}

# https://trac.ffmpeg.org/wiki/Encode/H.264
encode_h264() {
    #CRF="${CRF:-19}"
    if [[ $CRF -le 0 ]];
    then
        CRF=${CRF_DEFAULTS[h264]}
    fi
    if [[ $USE_CUDA -eq 1 ]]; 
    then
        VIDEO_CODEC="h264_nvenc"
    else
        VIDEO_CODEC="libx264"
    fi
    ffencode ${1} ${2}
}

# HEVC
# https://trac.ffmpeg.org/wiki/Encode/H.265
encode_h265() {
    #CRF="${CRF:-19}"
    if [[ $CRF -le 0 ]];
    then
        CRF=${CRF_DEFAULTS[h265]}
    fi
    if [[ $USE_CUDA -eq 1 ]]; 
    then
        VIDEO_CODEC="hevc_nvenc"
    else
        VIDEO_CODEC="libx265"
    fi
    ffencode ${1} ${2}
}

# Another name for 265
encode_hevc() {
    encode_h265 "$@"
}

# Will transcode a video trying to use the options set
# We perform multiple checking operations. 
# ${1} is the input file
# ${2} is the destination
#
# Steps are:
# 1) Perform movie check which should check for errors
# 2) Get size of original file
# 3) Perform transcode to a temporary file using ${TMPDIR}
# 4) Check compressed movie for errors
# 5) Check that the size of the new video is less than the old
# 6) Display message to user telling them the space savings
# 7) If all that is fine, place movie in desired location
# This allows you to overwrite a video file relatively safely.
# It isn't without error and we'll still overwrite if an error isn't
# caught and the output name is the same as the input name
# TODO: set minimum output file size checking
compress_video() {
    movie_check "${1}"
    if [[ "$?" -eq 0 ]];
    then
        echo "File starting with size:"
        init_size="$(du -h "${1}" | cut -f1)"
        init_size_num="$(echo "${init_size}" | sed -e 's/\([0-9]*\.[0-9]*\)[a-zA-Z]*/\1/g')"
        init_size_unit="$(echo "${init_size}" | sed -e 's/[0-9]*\.[0-9]*\([a-zA-Z]*\)/\1/g')"
        if [[ $(ffprobe_encoding "${1}") == "av1" ]];
        then
            error_msg "Movie is already in AV1 encoding. Skipping ..."
            return 1
        else
            # Set a temporary file that we'll output to in case the resultant is
            # bad so we don't overwrite the good movie
            tmp_file="${TMPDIR%/}/${2##*/}"
            # 23 is considered visually lossless for AV1
            case "${FORMAT}" in
                av1)
                    encode_av1 "${1}" "${tmp_file}"
                    ;;
                h264)
                    encode_h264 "${1}" "${tmp_file}"
                    ;;
                h265 | hevc)
                    encode_h265 "${1}" "${tmp_file}"
                    ;;
                *)
                    echo "Sorry, we don't support format ${FORMAT}. Try av1, h264, or h265 (hevc)"
                    return 1
                    ;;
            esac
            movie_check "$tmp_file"
            if [[ "$?" -ne 0 ]];
            then
                error_msg "An error occurred (${1})"
                error_msg "\tA temporary output is located at ${tmp_file}"
                return 1
            else
                output_size="$(du -h "${tmp_file}" | cut -f1)"
                output_size_num="$(echo "${output_size}" | sed -e 's/\([0-9]*\.[0-9]*\)[a-zA-Z]*/\1/g')"
                output_size_unit="$(echo "${output_size}" | sed -e 's/[0-9]*\.[0-9]*\([a-zA-Z]*\)/\1/g')"
                if [[ "${output_size_unit}" == "${init_size_unit}" && "${init_size_num}" -le "${output_size_num}" ]];
                then
                    echo "The initial file is smaller, so keeping (${init_size} <= ${output_size})"
                elif [[ "${init_size_unit}" == "G" ]];
                then
                    # We expect videos to really be G or M
                    if [[ "${output_size_unit}" != "M" || "${output_size_unit}" != "K" ]];
                    then
                        echo "Something went wrong unitwise with ${init_size} and ${output_size}"
                        return 1
                    fi
                    echo "The initial file is smaller, so keeping (${init_size} <= ${output_size})"
                else
                    echo "Congratulations: we've compressed the file from ${init_size} to ${output_size}"
                    mv "$tmp_file" "${2}"
                    return 0
                fi
            fi
        fi
    else
        error_msg "An error occurred (${1}): Skipping..."
        return 1
    fi
    return 0
}

# TODO
toav1_2pass() {
    ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i "${1}" -c:v av1_nvenc 
}

# Compare 2 videos using PSRN
# The second video should be the reference video
# https://ffmpeg.org/ffmpeg-filters.html#psnr
ff_psnr() {
    ffmpeg -i "${1}" -i "${2}" -filter_complex "psnr" -f null /dev/null
}

# Compare 2 videos with SSIM
# The second video should be the reference video
# https://ffmpeg.org/ffmpeg-filters.html#ssim
ff_ssim() {
    ffmpeg -i "${1}" -i "${2}" -lavfi  "ssim;[0:v][1:v]psnr" -f null -
}

usage() {
    cat << DOC
The script is still under alpha development so please read it instead.
Do not expect to be able to run this with flags and anything just yet.
DOC
}

parse_args() {
    unset INPUT_FILE
    unset OUTPUT_FILE

    while  [[ $# -gt 0 ]];
    do
        case $1 in
            #--av1 | toav1)
            #    shift
            #    input_movie="$1"
            #    if [[ $# -gt 0 ]];
            #    then
            #        output_movie="$2"
            #    else
            #        output_movie="$1"
            #    fi
            #    toav1 "${input_movie}" "${output_movie}"
            #    ;;
            #-c | check)
            #    shift 
            #    movie_check "$1"
            #    ;;
            #-e | encoding | get_encoding | ffprobe_encoding )
            #    shift
            #    ffprobe_encoding "$1"
            #    ;;
            -h | help)
                usage
                exit 0
                ;;
            -i | --input)
                shift
                INPUT_FILE="${1}"
                ;;
            -o | --output)
                shift
                OUTPUT_FILE="${1}"
                ;;
            -v | --verbose)
                let "DEBUG++"
                ;;
            *)
                if [[ -z ${INPUT_FILE} || "${INPUT_FILE}" == "" ]];
                then
                    INPUT_FILE="${1}"
                elif [[ -z ${OUTPUT_FILE} || "${OUTPUT_FILE}" == "" ]];
                then
                    OUTPUT_FILE="${1}"
                fi
                ;;
        esac
        shift
    done
    if [[ -z ${OUTPUT_FILE} || "${OUTPUT_FILE}" == "" ]];
    then
        OUTPUT_FILE="${OUTPUT_FILE:-"${INPUT_FILE}"}"
    fi
}

cleanup() {
    unset INPUT_FILE
    unset OUTPUT_FILE
    DEBUG=0
}

#is_sourced() {
#   if [ -n "$ZSH_VERSION" ]; then
#       case $ZSH_EVAL_CONTEXT in *:file:*) return 0;; esac
#   else  # Add additional POSIX-compatible shell names here, if needed.
#       case ${0##*/} in dash|-dash|bash|-bash|ksh|-ksh|sh|-sh) return 0;; esac
#   fi
#   return 1  # NOT sourced.
# }
#
#if [[ ! is_sourced ]];
#then
#    main "$@" || exit 1
#fi
#main "$@" || exit 1
