#!/usr/bin/env bash
################################################################################
# macOS system configuration
#
# Inspired by: https://github.com/mathiasbynens/dotfiles/blob/main/.macos
#
# Targets Apple Silicon.
# You'll also probably want to reboot to ensure everything takes effect.
#
# Author: Steven Walton
# Contact: dotfiles@walton.mozmail.com
# License: MIT
################################################################################
DOT_DIR="${DOT_DIR:-${HOME%/}/.dotfiles}"
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

# Refuse to run anywhere but macOS. `defaults` and `nvram` do not exist on Linux
# and the failure messages are confusing.
IsMacOS() {
    [[ "$(uname)" == "Darwin" ]]
}

# Several settings below need sudo. Ask once up front, then refresh the
# timestamp in the background so a long run doesn't stop to re-prompt.
KeepSudoAlive() {
    sudo -v || return 1
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
}
########################################

########################################
#          Xcode Command Line Tools
########################################
# Provides clang/ld/git and the headers almost everything else compiles against.
# Homebrew needs this before it can do anything useful, so it runs first.
# This opens a GUI dialog and returns immediately
XcodeCLT() {
    if xcode-select --print-path &>/dev/null; then
        gecho "Xcode command line tools already installed"
        return 0
    fi
    yecho "Installing Xcode command line tools (accept the GUI prompt)"
    xcode-select --install
}
########################################

########################################
#              System Defaults
########################################
SystemDefaults() {
    # ---------------------------------------------------------------- Boot ---
    # Mute the startup chime.
    # Apple Silicon uses StartupMute; the old Intel key (SystemAudioVolume=" ")
    # does nothing on these machines. %01 = muted, %00 = unmuted.
    gecho "Muting startup chime"
    sudo nvram StartupMute=%01

    # --------------------------------------------------------------- iCloud --
    # New documents default to the local disk instead of iCloud Drive.
    # iCloud stays available, it just stops being the implicit destination
    # nothing leaves the machine unless it is asked to.
    gecho "Defaulting new documents to disk, not iCloud"
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentToCloud -bool false

    # ----------------------------------------------------------- Text input --
    # Stop double-space from inserting a period.
    # System Settings > Keyboard > Input Sources > Edit > "Add period with
    # double-space"
    gecho "Disabling double-space period substitution"
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

    # Stop "smart" quotes and dashes. These silently replace ' " -- with typographic
    # characters, which corrupts anything pasted into a shell, an editor, or a
    # config file, and the resulting error never points at the real cause.
    gecho "Disabling smart quotes and dashes"
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # ------------------------------------------------------------- Trackpad --
    # Bottom-right corner of the trackpad acts as a right click.
    #
    #   TrackpadCornerSecondaryClick: 0 = off, 1 = bottom left, 2 = bottom right
    gecho "Mapping bottom-right trackpad corner to right click"
    defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
    defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
    # The -currentHost NSGlobalDomain pair is the per-machine copy the login
    # window and some system surfaces read. Kept for parity with the above.
    defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
    defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
}
########################################

########################################
#                 Finder
########################################
FinderDefaults() {
    # Sort folders before files rather than interleaving them alphabetically.
    gecho "Sorting folders first in Finder"
    defaults write com.apple.finder _FXSortFoldersFirst -bool true
    # Same behaviour on the Desktop, which reads a separate key.
    defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true

    # Always show file extensions. No hiding with double extensions...
    gecho "Showing all file extensions"
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Path bar: a breadcrumb strip along the bottom of every Finder window
    # showing the folder chain from the volume root down to where you are. You
    # can drag onto its segments to move things up the tree.
    # (Its sibling, ShowStatusBar, adds item count + free space. Uncomment if
    # you want that too.)
    gecho "Enabling Finder path bar"
    defaults write com.apple.finder ShowPathbar -bool true
    #defaults write com.apple.finder ShowStatusBar -bool true

    # Stop writing .DS_Store onto network shares and USB volumes. This is what
    # leaks them into zip files and onto other people's machines.
    gecho "Disabling .DS_Store on network and USB volumes"
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
}
########################################

########################################
#          Screenshots / Recordings
########################################
ScreenCaptureDefaults() {
    # Send screenshots to a dedicated folder instead of burying the Desktop.
    local shot_dir="${HOME%/}/Screenshots"
    gecho "Sending screenshots to ${shot_dir}"
    mkdir -p "${shot_dir}"
    defaults write com.apple.screencapture location -string "${shot_dir}"

    # png over the default. Valid values: png, jpg, pdf, tiff, gif, heic.
    # NOTE: this key governs *screenshots only*. macOS exposes no supported
    # defaults key for the screen-recording container because clearly everyone
    # loves .mov and no one would ever want mp4s! /s
    # ffmpeg -i foo.mov -c copy foo.mp4
    gecho "Setting screenshot format to png"
    defaults write com.apple.screencapture type -string "png"
}
########################################

########################################
#            Spaces / Multi-monitor
########################################
SpacesDefaults() {
    # Lost in Space? Not anymore!
    # Stop Mission Control reordering Spaces by most-recent-use.
    # System Settings > Desktop & Dock > "Automatically rearrange Spaces..."
    gecho "Disabling automatic Space rearrangement"
    defaults write com.apple.dock mru-spaces -bool false

    # ---- OPT-IN, currently off -------------------------------------------
    # spans-displays = true makes one Space stretch across all monitors instead
    # of each display owning its own Space. It changes multi-monitor behaviour
    # substantially (and full-screen apps stop blanking the other display), so
    # it is left commented until you decide you want it.
    #defaults write com.apple.spaces spans-displays -bool true
}
########################################

########################################
#              Apply Changes
########################################
# Restart the processes that cache these plists. Anything not covered here
# (nvram, some NSGlobalDomain keys) waits for a reboot.
ApplyChanges() {
    yecho "Restarting Finder, Dock and SystemUIServer"
    killall Finder &>/dev/null || true
    killall Dock &>/dev/null || true
    killall SystemUIServer &>/dev/null || true
}
########################################

main() {
    if ! IsMacOS; then
        recho "Not macOS (uname reports '$(uname)') -- refusing to run"
        return 1
    fi

    XcodeCLT || recho "Failed to install Xcode command line tools"

    KeepSudoAlive || {
        recho "Could not acquire sudo; skipping settings that require it"
        return 1
    }

    gecho "Applying system defaults"
    SystemDefaults      || recho "Some system defaults failed"
    FinderDefaults      || recho "Some Finder defaults failed"
    ScreenCaptureDefaults || recho "Some screencapture defaults failed"
    SpacesDefaults      || recho "Some Spaces defaults failed"

    ApplyChanges

    yecho "Some changes (startup chime, input settings) only apply after a reboot"
}

main "$@"
