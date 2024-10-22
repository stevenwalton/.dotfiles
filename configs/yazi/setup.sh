#!/usr/bin/env bash
# This is a setup file for yazi on a new machine
#
# Themes: https://github.com/yazi-rs/flavors

# https://github.com/BennyOe/tokyo-night.yazi
install_tokyo_night() {
    git clone https://github.com/BennyOe/tokyo-night.yazi.git \
        ~/.dotfiles/configs/yazi/flavors/tokyo-night.yazi
}

# https://github.com/yazi-rs/plugins
install_plugins() {
    # Full screen image plugin
    # https://github.com/yazi-rs/plugins/tree/main/max-preview.yazi
    #ya pack -a yazi-rs/plugins:max-preview

    # Add git support
    # https://github.com/yazi-rs/plugins/tree/main/git.yazi
    ya pack -a yazi-rs/plugins:git

    # Diff files with <C-d>
    # https://github.com/yazi-rs/plugins/tree/main/diff.yazi
    ya pack -a yazi-rs/plugins:diff

    # Add full border (a little cleaner)
    # https://github.com/yazi-rs/plugins/tree/main/full-border.yazi
    ya pack -a yazi-rs/plugins:full-border

    # Show mime type info
    # Not always needed but useful on weaker hardware
    # https://github.com/yazi-rs/plugins/tree/main/mime-ext.yazi
    #ya pack -a yazi-rs/plugins:mime-ext

}

main() {
    #install_tokyo_night
    install_plugins
}

main || exit 1
