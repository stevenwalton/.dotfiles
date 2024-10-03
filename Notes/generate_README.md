#!/usr/bin/env bash

make_header() {
    cat << EOF
# Dotfiles Notes
----------------
This README is autogenerated by [generate_README.sh](/Notes/generate_README.sh).
Please do not edit the README directly!

The project is organized as follows

$(header_info)

<sub><sup>Note: In vim press \`gf\` (goto-file) to go to selected file and <C-o> or <C-^> to go back (:e#)</sub></sup>
------------------------------------------------------------
$(make_toc)
------------------------------------------------------------
<sub><sup>NOTE: This README is autogenerated. Edit [make_readme](make_readme.sh) instead</sup></sub>

EOF
}
# ----------------------------------------------------------
# Inspired by jonavon: https://stackoverflow.com/a/61565622
# Gets the git directory tree and makes a markdown table
# of contents
# ----------------------------------------------------------
make_toc() {
    git ls-tree \
        --full-name \
        --name-only \
        -t \
        -r HEAD \
        | sed -e '/^\..*/d' \
        | sed -e "s/\([^-][^\/]*\/\)/   |\1/g" \
        -e "s/|\([^ ].*\/\(.*\)\)/- \[\2\]\(\1\)/" \
        | sed -e "s/^\([^ ].*\)/\[\1\]\(\1\)/" \
        | sed -e "s/\(.*\)/- \1/"
        
}

main() {
    make_header > README.md
}

main