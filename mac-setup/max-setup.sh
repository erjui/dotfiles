#!/bin/bash

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH=/opt/homebrew/bin:$PATH

# Install Homebrew packages
brew install git
brew install wget
brew install htop
brew install curl 

brew install node

brew install iterm2
brew install --cask visual-studio-code

brew install tree
