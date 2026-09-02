#!/usr/bin/env bash
################################################################################
# Generates configs/ghostty/os_config
#
# Tired of learning different movements on different machines? Me too! Fuck
# that! So let's make things easier and just switch it around. Since we can't
# make ghostty recognize what OS we're in, we can get around that with a simple
# bash script.
#
# macOS and Linux trade the names of the two modifiers nearest the spacebar:
#
#     Mac, leftward from the spacebar:   [space] Cmd    Option  Ctrl
#     PC,  leftward from the spacebar:   [space] Alt    Super   Ctrl
#
# The key BESIDE the spacebar is `cmd` on macOS and `alt` here. The key ONE OUT
# is `alt` on macOS and `super` here. Bindings written against either name are
# wrong on one of the two machines, so we name them by ROLE and let the platform
# decide the spelling:
#
#     $CMD -> the key beside the spacebar   (cmd on macOS,  alt on Linux)
#     $OPT -> the key one out               (alt on macOS,  super on Linux)
#
# Everything then reads like the macOS config, and the finger motion is
# identical on both machines even though the keycaps disagree.
#
# Run this on any new machine, or after editing the bindings below. It is
# standalone -- install.sh calls it, but nothing here depends on install.sh.
#
#     ./configs/ghostty/make_config.sh
#
# Author: Steven Walton
# Contact: dotfiles@walton.mozmail.com
# License: MIT
################################################################################
VERBOSE=1

########################################
#           Helper Functions
########################################
recho() {
    echo -e "\033[1;31m${1}\033[0m"
}

gecho() {
    echo -e "\033[1;32m${1}\033[0m"
}

yecho() {
    echo -e "\033[1;33m${1}\033[0m"
}
########################################

# Resolve against this script's own directory rather than DOT_DIR, so the
# generator works no matter where it is called from or where the repo lives.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="${SCRIPT_DIR}/config"

DetectOS() {
    case "$(uname)" in
        Darwin)
            OS="osx"
            CMD="cmd"
            OPT="alt"
            ;;
        Linux)
            OS="linux"
            CMD="alt"
            OPT="super"
            ;;
        *)
            recho "Unsupported OS '$(uname)': expected Darwin or Linux"
            return 1
            ;;
    esac
    gecho "Detected ${OS}: \$CMD=${CMD}, \$OPT=${OPT}"
}

# Contains the header to the generated file and will overwrite the new config
WriteHeader() {
    cat > "${OUT}" << EOF
################################################################################
# GENERATED FILE -- DO NOT EDIT
#
# Written by configs/ghostty/make_config.sh for ${OS}.
# For OS only edits please edit ${OS}_config.txt
#
#   \$CMD = ${CMD}   (key beside the spacebar)
#   \$OPT = ${OPT}   (key one out)
################################################################################
EOF
}

########################################
#            Shared Bindings
########################################
# Written once, spelled per platform. 
#   ${CMD} / ${OPT}   expanded here, at generation time
#   \${EDITOR} etc    passed through literally for the shell to expand later
#   \x1b  \r          left alone
WriteShared() {
    cat >> "$OUT" <<EOF

# Shortcut to open editor with \$EDITOR instead of notepad
keybind = ${CMD}+,=text:\${EDITOR} \${HOME%/}/.config/ghostty/config \r

#                   ########################################
#                               Global Keybinds
#                         (works even outside Ghostty)
#                   ########################################
# Quick Terminal (pops down from top)
# Would use t but uncomfortable so [ like ESC
#keybind = global:${CMD}+${OPT}+left_bracket=toggle_quick_terminal
keybind = global:${OPT}+left_bracket=toggle_quick_terminal
#quick-terminal-position = center

# opt + shift + t = new window
keybind = global:${OPT}+shift+t=new_window

#                   ########################################
#                                Splits / Panes
#                   ########################################
# Bound explicitly instead of riding on defaults. Ghostty ships different
# defaults per platform, which is why splitting felt wrong on Linux.
keybind = ${CMD}+d=new_split:right
keybind = ${CMD}+shift+d=new_split:down

# Move between splits
keybind = ${CMD}+${OPT}+left=goto_split:left
keybind = ${CMD}+${OPT}+right=goto_split:right
keybind = ${CMD}+${OPT}+up=goto_split:up
keybind = ${CMD}+${OPT}+down=goto_split:down

# Cycle panes
keybind = ${CMD}+left_bracket=goto_split:previous
keybind = ${CMD}+right_bracket=goto_split:next

# Blow the focused split up to fill the window (toggle)
keybind = ${CMD}+shift+enter=toggle_split_zoom

#                   ########################################
#                                    Tabs
#                   ########################################
keybind = ${CMD}+t=new_tab
keybind = ${CMD}+w=close_surface
# Cycle tabs
keybind = ${CMD}+shift+left_bracket=previous_tab
keybind = ${CMD}+shift+right_bracket=next_tab

#                   ########################################
#                                 Adjust Pane
#                   ########################################
keybind = ctrl+${CMD}+left=resize_split:left,20
keybind = ctrl+${CMD}+right=resize_split:right,20
keybind = ctrl+${CMD}+up=resize_split:up,20
keybind = ctrl+${CMD}+down=resize_split:down,20

# Rename the title of the surface (tab,window,etc)
keybind = ctrl+${OPT}+n=prompt_surface_title

#                   ########################################
#                                  Scrolling
#                   ########################################
keybind = ${CMD}+up=scroll_page_up
keybind = ${CMD}+down=scroll_page_down
# Scroll half pages (right for forward, left for back)
keybind = ${CMD}+right=scroll_page_fractional:0.25
keybind = ${CMD}+left=scroll_page_fractional:-0.25
# Testing some more vim like motions
keybind = ${CMD}+j=scroll_page_lines:1
keybind = ${CMD}+k=scroll_page_lines:-1
keybind = ${CMD}+shift+h=scroll_page_fractional:-1.0
keybind = ${CMD}+shift+m=scroll_page_fractional:0.50
keybind = ${CMD}+shift+l=scroll_page_fractional:1.00
# Same thing but vim-like bindings
# If we use actual vim bindings ghostty takes over... :(
# Issue is being worked on so these should work later
# (Does not work as of 1.3.0)
#   https://github.com/ghostty-org/ghostty/issues/4328
#keybind = performable:ctrl+F=scroll_page_fractional:0.5
#keybind = performable:ctrl+B=scroll_page_fractional:-0.5

#                   ########################################
#                                 Copy Actions
#                   ########################################
# Actions to copy and select from sections of cli
# These will write to a tmp file which the path will be in the clipboard
# Write entire scrollback to file
#keybind = ctrl+s=write_scrollback_file:copy
# Write contents of screen to file
# Was ${CMD}+shift+s, which collided with toggle_secure_input below. Ghostty
# keeps only the last binding for a trigger, so this one was silently dead.
keybind = ${CMD}+shift+f=write_screen_file:copy
# Write selection to file
#   This shouldn't be needed but whatever
keybind = ${OPT}+shift+s=write_selection_file:copy

#                   ########################################
#                                     Misc
#                   ########################################
# toggle secure input
keybind = ${CMD}+shift+s=toggle_secure_input
EOF
}

########################################
#           Common Bindings
#       True regardless of the OS
########################################
WriteCommon() {
    cat make_common.txt >> "$OUT"
}

########################################
#           macOS Only Bindings
########################################
WriteMacOnly() {
    cat make_osx.txt >> "$OUT"
}

########################################
#           Linux Only Bindings
########################################
WriteLinuxOnly() {
    cat make_linux.txt >> "$OUT"
}

########################################
#              Verification
########################################
# Catch a typo in the generator now rather than at Ghostty startup, where a bad
# keybind line is easy to miss.
Validate() {
    if ! command -v ghostty > /dev/null 2>&1; then
        yecho "ghostty not on PATH, skipping validation"
        return 0
    fi
    if ghostty +validate-config --config-file="$OUT" > /dev/null 2>&1; then
        gecho "Validated ${OUT}"
    else
        recho "Generated config FAILED validation:"
        ghostty +validate-config --config-file="$OUT"
        return 1
    fi
}

main() {
    DetectOS || return 1

    # os_config may currently be a symlink (older layout). Writing to a symlink
    # writes through it into the target, so clear it first.
    [[ -L "$OUT" ]] && rm -f "$OUT"

    # This overwrites config, all else append
    WriteHeader || { recho "Failed to write the header"; return 1; }

    WriteCommon || { recho "Failed writing Common section"; return 1; }

    WriteShared || { recho "Failed writing ${OUT}"; return 1; }
    if [[ "$OS" == "osx" ]]; then
        WriteMacOnly || { recho "Failed writing macOS section"; return 1; }
    elif [[ "$PS" == "linux" ]]; then
        WriteLinuxOnly || { recho "Failed writing Linux section"; return 1; }
    fi

    Validate || return 1
    gecho "Wrote $(grep -c '^keybind' "$OUT") keybinds to ${OUT}"
    yecho "Reload Ghostty's config to pick this up"
}

main "$@"
