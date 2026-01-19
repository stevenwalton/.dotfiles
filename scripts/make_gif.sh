#!/usr/bin/env bash
# This file is more of a "note" than a script
#
# You should really be editing this because I made this in a hacky way and
# haven't turned it into a real script yet.
# https://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html

start_time=00:00:00
end_time=00:00:30

rm /tmp/palette.png
rm "$2"
palette="/tmp/palette.png"
filters="fps=30,scale=1080:-1:flags=lanczos"

ffmpeg -ss $start_time -to $end_time -i "$1" -vf "$filters,palettegen" -y $palette && \
ffmpeg -ss $start_time -to $end_time -i "$1" -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y "$2"
