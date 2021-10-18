#!/bin/bash
set -u

#拷贝所有文件
pkill tafcored
pkill tafwalletd 
sleep 0.1
version=$1
cd /data/info/file
#scp -r yanfa-03@192.168.0.232:/data/info/download/release_${version} ./
scp -i /data/info/tafchain.pem -r root@121.41.193.65:/data/info/download/release_${version} ./

#安装bin文件
rm -rf  ~/tafsys
mkdir -p ~/tafsys/2.0/
cp -rf release_${version}/bin ~/tafsys/2.0/
export PATH=$PATH:~/tafsys/2.0/bin
