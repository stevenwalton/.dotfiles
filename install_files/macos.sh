# Inspired by https://github.com/mathiasbynens/dotfiles/blob/main/.macos
# disable boot sound
sudo nvram SystemAudioVolume=" "

# Save to disk and not iCloud by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentToCloud -bool false

# Disable automatic periods
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Map bottom right corner of trackpad to right click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
