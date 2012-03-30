#!/bin/bash
#rvm-test.sh

if [ ! -e ~/usr/local/rvm/scripts/rvm ]
then
  sudo bash -s stable < <(curl \
    -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
fi

# Manage some user roles - allow chef and default user to install gems
sudo useradd -m chef -s /bin/bash
sudo usermod -a -G admin chef
sudo usermod -a -G rvm chef
sudo usermod -a -G rvm `whoami`

# Copy a sudoers file that allows chef to run sudo without password
sudo cp sudoers /etc/sudoers