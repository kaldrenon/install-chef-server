# Update aptitude and install ruby dependencies
sudo apt-get update
sudo /usr/bin/apt-get install -y -q build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion

sudo useradd -m chef -s /bin/bash
sudo usermod -a -G admin chef

cd /tmp
wget http://kaldrenon.com/code/scripts/sudoers
sudo cp sudoers /etc/sudoers
wget http://kaldrenon.com/code/scripts/install-chef-server-1.9.3
chmod a+x install-chef-server-1.9.3
mv install-chef-server-1.9.3 /home/chef
sudo su - chef -c "./install-chef-server-1.9.3"
