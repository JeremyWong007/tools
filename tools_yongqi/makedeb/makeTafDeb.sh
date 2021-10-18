#!/bin/bash
set -u
set -x

mkdir -p ./tafDeb/usr/tafsys/0.0.1/bin/
cp -rf ~/tafsys/2.0/bin/* ./tafDeb/usr/tafsys/0.0.1/bin/

mkdir -p ./tafDeb/usr/bin

cd ./tafDeb/usr/bin
sudo ln -s ../tafsys/0.0.1/bin/tafclient tafclient
sudo ln -s ../tafsys/0.0.1/bin/tafcored tafcored
sudo ln -s ../tafsys/0.0.1/bin/tafwalletd tafwalletd
sudo ln -s ../tafsys/0.0.1/bin/tafsys-blocklog tafsys-blocklog
sudo ln -s ../tafsys/0.0.1/bin/tafsys-launcher tafsys-launcher

cd -
sudo dpkg-deb -b tafDeb/ tafSoftware_0.0.1.deb

#查看制作包的内容
sudo dpkg -c tafSoftware_0.0.1.deb

#查看是否安装了该软件
#sudo dpkg -s tafsys

#安装tafsys
#sudo dpkg -i tafSoftware_1.0.0.deb

#卸载tafsys
#sudo dpkg --remove tafsys
#sudo dpkg -r tafsys

#清除tafsys配置信息
#sudo dpkg --purge tafsys
#sudo dpkg -P tafsys