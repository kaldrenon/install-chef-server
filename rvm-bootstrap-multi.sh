#!/usr/bin/env bash

# Install git
sudo bash < <( curl -s https://rvm.beginrescueend.com/install/git )

# Install RVM
sudo bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )

# Install some Rubies
source "/usr/local/rvm/scripts/rvm"
rvm install 1.9.2,1.9.3
