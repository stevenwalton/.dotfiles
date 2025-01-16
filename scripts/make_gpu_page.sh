#!/usr/bin/env bash
############################################################
# Stupid bash script to make a web page for machine status
# It's cumbersome and verbose but it's readable and 
# maintainable. 
# The basic idea is that it runs nvidia-smi commands on
# remote machines and then writes that to an HTML
# document in a relatively nice format.
# If you set up a cron job or systemd job to run this
# at certain intervals then the page will be updated
# at those intervals.
# Thus you have a quick and dirty way to make a static
# webpage that gives you some GPU info about if your
# machines are in use or not.
# Sure, you could ssh a list of machines but now you can
# redirect people that are afraid of the terminal to this
# website and actually get them to check machine status
# before stepping on somebody else's job! (hopefully)
# Especially when those jobs have dynamic memory
# usage and so they start their job and yours crashes :(
#
# This script works under the assumption of GNU bash
# To make sure it works try doing this in your terminal
# (switch to bash if you use zsh or another shell)
# FOO="Hello World"
# echo ${FOO^^}
# If this prints "HELLO WORLD" then you're fine
#
# Author: Steven Walton
# License: MIT
# Contact: scripts@walton.mozmail.com
############################################################

# Name of the file that we will write output to
PAGE_NAME=
# These variables will be used so defined here 
GPU_INFO=
GPU_INFO_OPTIONS=()
GPU_INFO_OPTIONS_NAMES=()
# Paths to your data disks
# e.g. /home /mnt/datasets /mnt/mass_storage
DF_LOC=
# Machines are in the format hostname-#
# e.g. foo-01 foo-02 foo-03 ...
# We assume that there is a leading 0 for values <10
# See get_all_machines()
MACHINE_BASE_NAME=
# MACHINE RANGE
declare -i MIN_MACHINE=
declare -i MAX_MACHINE=
# TODO
#COLORS=("#0d0887" "#46039f" "#7201a8" "#9c179e" "#bd3786" "#d8576b" "#ed7953" "#fb9f3a" "#fdca26" "#f0f921")

# I know this is verbose and cumbersome but it allows for easier turning on and
# off
make_gpu_info_options() {
    GPU_INFO_OPTIONS+=("index")
    GPU_INFO_OPTIONS_NAMES+=("INDEX")
    #
    GPU_INFO_OPTIONS+=("name")
    GPU_INFO_OPTIONS_NAMES+=("NAME")
    #
    GPU_INFO_OPTIONS+=("utilization.gpu")
    GPU_INFO_OPTIONS_NAMES+=("UTIL")
    #
    GPU_INFO_OPTIONS+=("memory.used")
    GPU_INFO_OPTIONS_NAMES+=("MEM_USED")
    #
    GPU_INFO_OPTIONS+=("memory.total")
    GPU_INFO_OPTIONS_NAMES+=("MEM_TOT")
    #
    GPU_INFO_OPTIONS+=("utilization.memory")
    GPU_INFO_OPTIONS_NAMES+=("MEM_UTIL")
    #
    GPU_INFO_OPTIONS+=("fan.speed")
    GPU_INFO_OPTIONS_NAMES+=("FAN_SPD")
    #
    GPU_INFO_OPTIONS+=("temperature.gpu")
    GPU_INFO_OPTIONS_NAMES+=("TEMPER")
    #
    GPU_INFO_OPTIONS+=("power.draw")
    GPU_INFO_OPTIONS_NAMES+=("PWR")
    #
    GPU_INFO_OPTIONS+=("power.limit")
    GPU_INFO_OPTIONS_NAMES+=("MAX_PWR")
    #
    GPU_INFO_OPTIONS+=("power.max_limit")
    GPU_INFO_OPTIONS_NAMES+=("MAX_P_PWR")
    #
    GPU_INFO_OPTIONS+=("clocks.gr")
    GPU_INFO_OPTIONS_NAMES+=("GCLK")
    #
    GPU_INFO_OPTIONS+=("clocks.max.gr")
    GPU_INFO_OPTIONS_NAMES+=("MAX_GCLK")
    #
    GPU_INFO_OPTIONS+=("clocks.sm")
    GPU_INFO_OPTIONS_NAMES+=("SM_CLK")
    #
    GPU_INFO_OPTIONS+=("clocks.max.sm")
    GPU_INFO_OPTIONS_NAMES+=("MAX_SM_CLK")
    #
    GPU_INFO_OPTIONS+=("clocks.mem")
    GPU_INFO_OPTIONS_NAMES+=("MEM_CLK")
    #
    GPU_INFO_OPTIONS+=("clocks.max.mem")
    GPU_INFO_OPTIONS_NAMES+=("MAX_MEM_CLK")
    #
    GPU_INFO_OPTIONS+=("clocks.video")
    GPU_INFO_OPTIONS_NAMES+=("VCLK")
    # Join as comma separated
    #echo "GPU queries are"
    #echo "${GPU_INFO_OPTIONS[@]}"
    # Make comma separated
    IFS=,
    GPU_INFO_OPTIONS=$(echo "${GPU_INFO_OPTIONS[*]}")
    #echo "GPU_INFO_OPTIONS = $GPU_INFO_OPTIONS"
}

parse_line() {
    CUR_COL=1
    for VAR_NAME in ${GPU_INFO_OPTIONS_NAMES[@]};
    do
        VAR=$(get_item "$1" $CUR_COL)
        case $VAR_NAME in
            "INDEX") INDEX="$VAR" ;;
            "NAME") GPU_NAME="$VAR" ;;
            "UTIL") GPU_UTIL="$VAR" ;;
            "MEM_USED") MEM_USED="$VAR" ;;
            "MEM_TOT") MEM_TOT="$VAR" ;;
            "MEM_UTIL") MEM_UTIL="$VAR" ;;
            "FAN_SPD") FAN_SPD="$VAR" ;;
            "TEMPER") TEMPER="$VAR" ;;
            "PWR") PWR="$VAR" ;;
            "MAX_PWR") MAX_PWR="$VAR" ;;
            "MAX_P_PWR") MAX_P_PWR="$VAR" ;;
            "GCLK") GCLK="$VAR" ;;
            "MAX_GCLK") MAX_GCLK="$VAR" ;;
            "SM_CLK") SM_CLK="$VAR" ;;
            "MAX_SM_CLK") MAX_SM_CLK="$VAR" ;;
            "MEM_CLK") MEM_CLK="$VAR" ;;
            "MAX_MEM_CLK") MAX_MEM_CLK="$VAR" ;;
            "VCLK") VCLK="$VAR" ;;
            *)
                ;;
        esac
        ((CUR_COL++))
    done
}

page_header() {
    cat << EOF
<!DOCTYPE html>
<html>
<style>
table, th, td {
  border: 2px solid black;
  border-collapse: collapse;
  padding: 5px;
}
th {
  text-align: center;
}
tr {
  text-align: center;
}
</style>
<body>
<h1>GPU Status</h1>
<small>$(date +'%D %H:%M')</small>
EOF
}

page_tail() {
    cat << EOF
</body>
</html>
EOF
}

get_item() {
    echo "$1" | cut -d"," -f$2
}

get_gpu_info() {
    echo -e "\n<!-- ${MACHINE_BASE_NAME}-$1 -->" >> "${PAGE_NAME}_stage"
    # Note that ^^ old works in GNU bash
    echo "<h3>${MACHINE_BASE_NAME^^}-$1</h3>" >> "${PAGE_NAME}_stage"
    declare error_out
    GPU_INFO=$(ssh ${MACHINE_BASE_NAME}-$1 nvidia-smi --format=csv,noheader --query-gpu="$GPU_INFO_OPTIONS")
    # Do error handling to reduce cron emails
    if [[ "$?" -ne 0 ]];
    then
        echo "Error accessing GPU info on ${MACHINE_BASE_NAME}-${1}" >> ${PAGE_NAME}_stage
        echo "Error: ${GPU_INFO}" >> ${PAGE_NAME}_stage
        return 1
    fi
    NUM_ROWS=$(echo $GPU_INFO | wc -l | tr -d '[:blank:]')
    # Unnecessary since we have GPU_INFO_OPTIONS_NAMES but useful for debugging
    # NUM_COLS=$(echo $GPU_INFO | awk -F',' '{print NF}')
    #LINE_NUM=0
    echo "<table>" >> "${PAGE_NAME}_stage"

    echo -e "\t<tr>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>Index</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>GPU Name</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>Memory</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>Utilization</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>Power</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>Temperature</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>Fan Speed</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>Graphics Clock</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>SM Clock</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>Memory Clock</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t</tr>" >> "${PAGE_NAME}_stage"
    echo "$GPU_INFO" | while IFS= read -e line;
    do
        #echo "Got line ${line}"
        parse_line "$line"
        echo -e "\t<!-- GPU ${INDEX} -->" >> "${PAGE_NAME}_stage"
        echo -e "\t<tr>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${INDEX}</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${GPU_NAME}</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${MEM_USED} / ${MEM_TOT} (${MEM_UTIL})</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${GPU_UTIL}</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${PWR} / ${MAX_PWR} (${MAX_P_PWR})</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${TEMPER} C</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${FAN_SPD}</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${GCLK} / ${MAX_GCLK}</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${SM_CLK} / ${MAX_SM_CLK}</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${MEM_CLK} / ${MAX_MEM_CLK}</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t</tr>" >> "${PAGE_NAME}_stage"
        #((LINE_NUM++))
        #echo -e "$INDEX\t$GPU_NAME\t$GPU_UTIL\t$MEM_USED / $MEM_TOT\t$TEMPER" >> "${PAGE_NAME}_stage"
    done 
    echo -e "</table>" >> "${PAGE_NAME}_stage"
}

get_memory() {

    # Get df info. h makes human format, P makes poxix. Remove first line and
    # then only store Size/Used/Avail
    DF_INFO=$(ssh ${MACHINE_BASE_NAME}-$1 df -hP "$DF_LOC" | awk 'NR != 1' | awk '{print $2,$3,$4}')
    if [[ "$?" -ne 0 ]];
    then
        echo "Error accessing MEMORY info on ${MACHINE_BASE_NAME}-${1}" >> ${PAGE_NAME}_stage
        echo "Error: ${DF_INFO}" >> ${PAGE_NAME}_stage
        return 1
    fi
    #echo "$DF_INFO" >> "${PAGE_NAME}_stage"
    echo -e "\n<!-- disk space -->" >> "${PAGE_NAME}_stage"
    echo "<table>" >> "${PAGE_NAME}_stage"
    echo -e "\t<tr>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>Location</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>Capacity</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>Used</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t\t<th>Available</th>" >> "${PAGE_NAME}_stage"
    echo -e "\t</tr>" >> "${PAGE_NAME}_stage"
    LINE_NUM=0
    #echo -e "DF_INFO = $DF_INFO"
    echo -e "$DF_INFO" | while IFS= read -r line;
    do
        case $LINE_NUM in
            0) SPACE_NAME="home";;
            1) SPACE_NAME="data";;
            2) SPACE_NAME="workspace";;
            *);;
        esac
        ((LINE_NUM++))
        # For some stupid reason this read line works in a terminal but isn't
        # working in this script so let's do it with cut because why the fuck
        # not?
        #echo -e "$line" | read -r DISK_SIZE DISK_USED DISK_AVAIL
        DISK_SIZE=$(echo "$line" | cut -d " " -f1)
        DISK_USED=$(echo "$line" | cut -d " " -f2)
        DISK_AVAIL=$(echo "$line" | cut -d " " -f3)
        echo -e "\t<tr>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${SPACE_NAME}</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${DISK_SIZE}</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${DISK_USED}</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t\t<td>${DISK_AVAIL}</td>" >> "${PAGE_NAME}_stage"
        echo -e "\t</tr>" >> "${PAGE_NAME}_stage"
    done
    echo "</table>" >> "${PAGE_NAME}_stage"
    echo "<br>" >> "${PAGE_NAME}_stage"
}

get_all_machines() {
    # This is necessary to get sequence to work properly
    unset IFS
    for i in $(seq -f "%02g"  $MIN_MACHINE $MAX_MACHINE);
    do
        #echo -e "Collecting MACHINE-$i"
        get_gpu_info $i;
        get_memory $i;
        #echo -e "$GPU_INFO" >> "${PAGE_NAME}_stage";
    done
}

main_body() {
    echo $ALL_GPU_INFO
}

main() {
    make_gpu_info_options
    page_header > "${PAGE_NAME}_stage"
    get_all_machines
    page_tail >> "${PAGE_NAME}_stage"
    mv "${PAGE_NAME}_stage" "${PAGE_NAME}"
}

main
