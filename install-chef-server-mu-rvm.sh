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

# Manage some user roles - allow chef and default user to install gems
sudo useradd -m chef -s /bin/bash
sudo usermod -a -G admin chef
sudo usermod -a -G rvm chef
sudo usermod -a -G rvm `whoami`

# Copy a sudoers file that allows chef to run sudo without password
wget https://raw.github.com/kaldrenon/install-chef-server/master/sudoers
sudo cp sudoers /etc/sudoers
rm sudoers

# This ugly mess enables this script to all be run from one file. Because user
# group settings are only updated at login, the default user won't be able to
# install ruby with a simple invocation, and entering a new session will 
# interrupt and kill the script. However, su -c enables us to run a command
# sequence as another user, and -l performs a login. Here, we log in /as the 
# same user/ and run the remaining commands:
#
#   - Put RVM into mixed mode (separate rubies and gemsets per user)
#   - Install 1.9.3 as default user
#   - Download chef installation script
#   - Make the script executable, move it to chef's home dir and chown it
#   - Run the script as the chef user
sudo su -l $USER -c "rvm user all;
  rvm install 1.9.3; 
  rvm use 1.9.3- --default; 
  chmod a+x install-chef-server.sh;
  sudo chown -R chef /home/ubuntu/install-chef-server;
  sudo su - chef -c \"/home/ubuntu/install-chef-server/install-chef-server.sh\""