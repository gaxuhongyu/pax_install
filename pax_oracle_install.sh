#!/bin/bash

ORACLE_BASE=/home/oracle/oracle_home
ORACLE_HOME=$ORACLE_BASE/11.2.0
ORACLE_DATA=$ORACLE_BASE/db_file
ORACLE_DATA_BACKUP=$ORACLE_BASE/db_file_backup
ORACLE_INVENTORY=$ORACLE_BASE/inventory

echo ORACLE_BASE:$ORACLE_BASE
echo ORACLE_HOME:$ORACLE_HOME
echo ORACLE_DATA:$ORACLE_DATA
echo ORACLE_DATA_BACKUP:$ORACLE_DATA_BACKUP
echo ORACLE_INVENTORY:$ORACLE_INVENTORY

echo "Install oracle dependence software... "
sudo yum install -y make
sudo yum install -y gcc
sudo yum install -y binutils
sudo yum install -y gcc-c++
sudo yum install -y compat-libstdc++
sudo yum install -y elfutils-libelf-devel
sudo yum install -y elfutils-libelf-devel-static
sudo yum install -y ksh
sudo yum install -y libaio
sudo yum install -y libaio-devel
sudo yum install -y numactl-devel
sudo yum install -y sysstat
sudo yum install -y unixODBC
sudo yum install -y unixODBC-devel
sudo yum install -y pcre-devel

echo "Add user and group"
sudo groupadd oinstall
sudo groupadd dba
sudo useradd -g oinstall -G dba -d /home/oracle oracle
echo "Plsase set user oracle password:"
sudo passwd oracle

sudo cat <<EOF >> /etc/sysctl.conf
fs.aio-max-nr                   = 1048576
fs.file-max                     = 6553600
kernel.shmall                   = 2097152
kernel.shmmax                   = 2147483648
kernel.shmmni                   = 4096
kernel.sem                      = 250 32000 100 128
net.ipv4.ip_local_port_range    = 1024 65000
net.core.rmem_default           = 262144
net.core.rmem_max               = 4194304
net.core.wmem_default           = 262144
net.core.wmem_max               = 1048586
EOF
sudo sysctl -p

sudo cat <<EOF >> /etc/security/limits.conf
oracle           soft    nproc           2047
oracle           hard    nproc           16384
oracle           soft    nofile          1024
oracle           hard    nofile          65536
oracle           soft    stack           10240
EOF

sudo cat <<EOF >>/etc/pam.d/login
session   required  /lib64/security/pam_limits.so
session   required  pam_limits.so
EOF
# 64为系统，千万别写成/lib/security/pam_limits.so，否则导致无法登录
sudo cat <<EOF >>/etc/profile
if [ $USER = "oracle" ]; then
  if [ $SHELL = "/bin/ksh" ]; then
    ulimit -p 16384
    ulimit -n 65536
  else
    ulimit -u 16384 -n 65536
  fi 
fi
EOF

sudo mkdir -p $ORACLE_BASE        #数据库系统安装目录
sudo mkdir -p $ORACLE_HOME        #数据库数据安装目录
sudo mkdir -p $ORACLE_DATA        #数据文件存放目录
sudo mkdir -p $ORACLE_DATA_BACKUP #数据文件备份目录
sudo mkdir -p $ORACLE_INVENTORY   #清单目录
sudo chown -R oracle:oinstall $ORACLE_BASE
sudo chown -R oracle:oinstall $ORACLE_INVENTORY
sudo chown -R oracle:oinstall $ORACLE_DATA
sudo chown -R oracle:oinstall $ORACLE_DATA_BACKUP
sudo chomod -R 775 $ORACLE_BASE
sudo chomod -R 775 $ORACLE_DATA



su oracle -c cat <<EOF >>/home/oracle/.bash_profile
export ORACLE_BASE=/home/oracle/oracle_home
export ORACLE_HOME=$ORACLE_BASE/11.2.0
export PATH=$PATH:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
export CLASSPATH
PATH=$PATH:/usr/bin:/etc:/usr/sbin:/usr/ucb:$HOME/bin:/usr/bin/X11:$ORACLE_HOME/bin:/oracle/OPatch:/sbin:/usr/vac/bin:.
export PATH
EOF
