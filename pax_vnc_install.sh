#!/bin/bash
sudo sh -c "echo exclude=NetworkManager* >> /etc/yum.conf"
sudo yum clean all
sudo yum groupinstall basic-desktop desktop-platform x11 fonts
sudo rpm -Uvh http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm 
sudo rpm -Uvh http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm 
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm 
sudo yum -y update
sudo yum repolist
sudo yum install -y xrdp tigervnc-server autoconf automake libtool openssl-devel pam-devel libX11-devel libXfixes-devel
#wget http://jaist.dl.sourceforge.net/project/xrdp/xrdp/0.6.1/xrdp-v0.6.1.tar.gz
#echo ${PWD}
#tar -zxvf xrdp-v0.6.1.tar.gz
#sudo mv xrdp-v0.6.1 /usr/xrdp-v0.6.1
#sudo sh -c cd /usr/xrdp-v0.6.1/ && /usr/xrdp-v0.6.1/bootstrap && /usr/xrdp-v0.6.1/configure && sudo make && sudo make install
sudo groupadd tsusers
sudo groupadd tsusers
sudo groupadd tsadmins
sudo echo "tsusers:x:501:jason" | sudo tee -a /etc/group
sudo echo "tsadmins:x:502:root" | sudo tee -a /etc/group
echo "setting you vnc password"
vncpasswd
sudo echo VNCSERVERS=\"1:jason\" | sudo tee -a /etc/sysconfig/vncservers
sudo echo VNCSERVERARGS\[1\]=\"-geometry 1440x900 -depth 32\" | sudo tee -a /etc/sysconfig/vncservers 
#sudo echo "/etc/xrdp/xrdp.sh start" | sudo tee -a /etc/rc.local
sudo chkconfig vncserver on
sudo service vncserver on
sudo service vncserver start
#sudo /etc/xrdp/xrdp.sh start
