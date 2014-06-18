#!/usr/bin/env bash
sudo apt-get update
<<<<<<< HEAD
sudo apt-get install -y git make mongodb openjdk-7-jre-headless g++ isc-dhcp-server ipxe tftp tftpd curl zlib1g-dev libssl-dev
>>>>>>> master

#Configure tftpd
[ ! -d /tftpboot ] && sudo mkdir /tftpboot
sudo chmod -R 777 /tftpboot
sudo chown -R nobody /tftpboot

sudo cp /vagrant/tftp /etc/xinetd.d/tftp
sudo service xinetd reload

#Copy ipxe files to tftpboot
cp -r /usr/lib/ipxe/* /tftpboot

#Patch general.h
cd ~
git clone git://git.ipxe.org/ipxe.git
wget https://gist.githubusercontent.com/jcpowermac/7cc13ce51816ce5222f4/raw/4384911a921a732e0b85d28ff3485fe18c092ffd/image_comboot.patch
patch -p0 < image_comboot.patch
rm image_comboot.patch

# Install pxelinux
wget https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.02.tar.gz
tar -zxvf syslinux-6.02.tar.gz --strip-components 3 -C /tftpboot syslinux-6.02/bios/core/pxelinux.0
tar -zxvf syslinux-6.02.tar.gz --strip-components 4 -C /tftpboot syslinux-6.02/bios/com32/menu/menu.c32

[ ! -d /tftpboot/pxelinux.cfg ] && mkdir /tftpboot/pxelinux.cfg
sudo cp /vagrant/default /tftpboot/pxelinux.cfg/default

#Configure DHCPd
sudo cp /vagrant/dhcpd.conf /etc/dhcp/dhcpd.conf

#Get Hanlon
sudo mkdir /opt/hanlon/
sudo chmod -R 777 /opt/hanlon/
sudo chown -R nobody /opt/hanlon/

#Get Hanlon
cd /opt/hanlon/
git clone https://github.com/csc/Hanlon.git .

#Install rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

#Install ruby-build tool
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
./~/.rbenv/plugins/ruby-build/install.sh

#Install rubies
ruby-build 1.9.3-p547 ~/.rbenv/versions/1.9.3-p547 --with-openssl-dir=/usr/local
rbenv global 1.9.3-p547
gem install bundler trinidad
rbenv rehash
bundle install

ruby-build jruby-1.7.12 ~/.rbenv/versions/jruby-1.7.12 --with-openssl-dir=/usr/local
rbenv global jruby-1.7.12
gem install bundler trinidad
rbenv rehash
bundle install

./hanlon_init