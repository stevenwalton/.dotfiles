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
# https://github.com/AnirudhG07/awesome-yazi
install_plugins() {
    # Full screen image plugin
    # https://github.com/yazi-rs/plugins/tree/main/max-preview.yazi
    #ya pack -a yazi-rs/plugins:max-preview
    # New version is
    ya pack -a yazi-rs/plugins:toggle-pane

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
    ya pack -a yazi-rs/plugins:mime-ext

    # Preview ipynb notebooks
    ya pack -a AnirudhG07/nbpreview

    # Better media info and preview
    # https://github.com/boydaihungst/mediainfo.yazi
    ya pack -a boydaihungst/mediainfo
    if (! _exists mediainfo)
    then
        if [[ $(uname) == "Linux" ]];
        then
            if ( _exists pacman )
            then
                sudo pacman -S mediainfo
            else
                echo -e "\033[1;31mERROR:\033[0m You need to install mediainfo maually"
            fi
        elif [[ $(uname) == "Darwin" ]];
        then
            if ( _exists brew )
            then
                brew install mediainfo
            else
                echo -e "\033[1;31mERROR:\033[0m You need to install mediainfo maually"
            fi
        fi
    fi

}

function _exists() {
    command -v "$1" &> /dev/null
}

main() {
    # Update just in case
    ya pack -u
    #install_tokyo_night
    install_plugins
}

main || exit 1
