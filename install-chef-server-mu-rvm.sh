#!/bin/bash

# Update aptitude and install ruby dependencies
sudo apt-get update
sudo /usr/bin/apt-get install -y -q build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion

# install rvm multi-user
# http://beginrescueend.com/rvm/install/
if [ ! -e ~/usr/local/rvm/scripts/rvm ]
then
  sudo bash -s stable < <(curl \
    -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
fi

# Put RVM into mixed mode (separate rubies and gemsets per user)
rvm user all

# Manage some user roles - allow chef and default user to install gems
sudo useradd -m chef -s /bin/bash
sudo usermod -a -G admin chef
sudo usermod -a -G rvm chef
sudo usermod -a -G rvm `whoami`

# Copy a sudoers file that allows chef to run sudo without password
wget http://kaldrenon.com/code/scripts/sudoers
sudo cp sudoers /etc/sudoers
rm sudoers

#Install 1.9.3 as default user
rvm install 1.9.2 
rvm use 1.9.2 --default

#Install 1.9.2 and chef stack as chef
wget http://kaldrenon.com/code/scripts/install-chef-server.sh
chmod a+x install-chef-server.sh
sudo -u chef ./install-chef-server