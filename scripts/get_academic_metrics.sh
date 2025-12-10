#!/usr/bin/env bash
########################################
# Small script to extract your 
# scholarly metrics from Google Scholar
# You can print these in a formatted way
# or just grab the numbers.
# It'll grab your total citations, h-index,
# and i-10.
#
# Author: Steven Walton
# LICENSE: MIT
########################################

GSCHOLAR_PAGE=${GSCHOLAR:-he4JY7wAAAAJ}
OUTPUT_FILE=${OUTPUT_FILE:-/dev/stdout}
METRICS=(1 3 5)
FORMATTED=1

grep_scholar() {
    curl -LSs "https://scholar.google.com/citations?user=${GSCHOLAR_PAGE}" | \
      grep 'Citations' | \
      grep -o '<td class="gsc_rsb_std">[0-9]*</td>' 
}

# Prepend with labels
format_metrics() {
    awk \
        -v L1="${METRICS[0]}" \
        -v L2="${METRICS[1]}" \
        -v L3="${METRICS[2]}" '{
        gsub(/<[^>]*>/, "");
        if (NR==L1) print "Citations: " $0;
        else if (NR==L2) print "h-index: " $0;
        else if (NR==L3) print "i-10: " $0
    }' 
}

# Don't do the prepends
parse_metrics() {
    awk \
        -v L1="${METRICS[0]}" \
        -v L2="${METRICS[1]}" \
        -v L3="${METRICS[2]}" '{
        gsub(/<[^>]*>/, "");
        if (NR==L1) print $0;
        else if (NR==L2) print $0;
        else if (NR==L3) print 
    }' 
}

usage() {
    cat << EOF 
A simple script to print your google scholar metrics.

Usage: ./get_academic_metrics.sh [OPTIONS]

Options:
    -h, --help
        Print this message
    -i, --gscholar-id
        Provide your Google scholar ID (\$GSCHOLAR_PAGE)
    -r, --recent
        Print metrics for recent 5 years
    -o, --output
        Output to file (\$OUTPUT_FILE)
    -u, --unformatted
        Only print numbers (\$FORMATTED)
EOF
}

get_args() {
    while [[ $# -gt 0 ]];
    do
        case $1 in
            -h | --help)
                usage
                exit 0
                ;;
            -i | --gscholar-id)
                shift
                GSCHOLAR_PAGE="${1}"
                ;;
            -r | --recent)
                METRICS=(2 4 6)
                shift
                ;;
            -o | --output)
                shift
                OUTPUT_FILE="$1"
                shift
                ;;
            -u | --unformatted)
                FORMATTED=0
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
}

main() {
    get_args "$@"

    if [[ ${FORMATTED} != 0 ]];
    then
        grep_scholar | format_metrics > "${OUTPUT_FILE}"
    else
        grep_scholar | parse_metrics > "${OUTPUT_FILE}"
    fi
}

main "$@" || exit 1
