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
sudo cp sudoers /etc/sudoers

# This su creates a new login session for the active user, allowing the recent
# user modifications to count when rvm install is invoked.
#
#   - Put RVM into mixed mode (separate rubies and gemsets per user)
#   - Install 1.9.3 as default user
sudo su -l $USER -c "rvm user all; rvm install 1.9.3; rvm use 1.9.3 --default"

# Make sure the scripts are executable by chef
chmod a+x /home/ubuntu/install-chef-server/*.sh;
sudo chown -R chef /home/ubuntu/install-chef-server;

# Install 1.9.2 as default as chef user (using same login trick as before)
sudo su - chef -l -c "rvm install 1.9.2; rvm use 1.9.2 --default"

# Run the remainder of the chef-server install as chef
sudo su - chef -l -c "cd /home/ubuntu/install-chef-server; 
                      ./install-chef-server.sh"