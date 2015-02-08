#!/bin/sh

########################################################
# Homebrew
# install command line tools
########################################################

# install homebrew if not installed yet
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "installing binaries..."

# update homebrew
brew update

# install GNU core utilities
brew install coreutils

# install GNU find utils
brew install findutils

# install bash
brew install bash

# install more recent versions of some osx tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

# install misc
misc=(
	ack
	ffmpeg
	git
	hub
	node
	python
	rename
	tmux
	trash
	tree
	zsh
)
brew install ${misc[@]}

# install rvm
\curl -sSL https://get.rvm.io | bash -s stable


########################################################
# Cask
# install binary apps
########################################################

# install cask
brew install caskroom/cask/brew-cask
brew tap caskroom/versions
brew tap caskroom/fonts

# apps
apps=(
	alfred
	appcleaner
	atom
	backblaze
	betterzip
	boot2docker
	carbon-copy-cloner
	doxie
	dropbox
	fantastical
	geektool
	google-chrome-beta
	istat-menus
	iterm2
	java
	jdownloader2
	mailbox
	moneymoney
	nvalt
	qlcolorcode
	qlmarkdown
	qlprettypatch
	qlstephen
	quicklook-json
	spotify
	sublime-text3
	tower
	virtualbox
	vlc
	ynab
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}
# link alfred to new apps
brew cask alfred link


########################################################
# Dotfiles
# fetch latest dotfiles from github
########################################################

# install dotfiles
git clone https://github.com/davidtrautmann/dotfiles.git && dotfiles/install.sh && rm -rf dotfiles


########################################################
# OSX Environment and Defaults
########################################################

# setting up mac dev environment...
echo "Setting up mac dev environment..."
COMPUTER_NAME="macbook"
sudo scutil --set ComputerName $COMPUTER_NAME
sudo scutil --set HostName $COMPUTER_NAME
sudo scutil --set LocalHostName $COMPUTER_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME
# hide spotlight icon
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# Expanding the save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
# disable the hdd motion sensor
sudo pmset -a sms 0
# disable system-wide resume
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# save to disk and not to iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# reveal ip address, hostname, osx version, etc. when clicking the clock in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
# check for software updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
# disable smart quotes and smart dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# add ability to toggle between light and dark mode in using ctrl+opt+cmd+t
sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
# speeding up wake from sleep to 24 hours from an hour
sudo pmset -a standbydelay 86400
# enabling full keyboard access for all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
# setting fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0
# setting trackpad & mouse speed
defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 2.5
# turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300
# requiring password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
# setting screenshot location to ~/Desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"
# setting screenshot format to PNG
defaults write com.apple.screencapture type -string "png"
# show status bar in Finder by default
defaults write com.apple.finder ShowStatusBar -bool true
# display full POSIX path in finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# avoid creation of .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
# allowing text selection in quick look
defaults write com.apple.finder QLEnableTextSelection -bool true
# wipe all default icons from the dock
defaults write com.apple.dock persistent-apps -array
# setting the icon size of dock items to 48
defaults write com.apple.dock tilesize -int 48
# set dock to auto-hide and remove the auto-hiding delay
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
# enabling UTF-8 only in terminal.app
defaults write com.apple.terminal StringEncodings -array 4
# prevent time machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
# disable local time machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal
# setting git default editor to sublime text
git config --global core.editor "subl -n -w"


########################################################
# Finalizing
########################################################

# cleanup brew and cask
brew cleanup
brew cask cleanup

# killing apps for changes taking effect
echo "killing open applications"
find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
  for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
    "Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
    "Terminal" "Transmission"; do
    killall "${app}" > /dev/null 2>&1
  done
