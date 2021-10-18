#!/bin/bash
set -u
set -x

#说明
#$1 源文件地址
#$2 文件目标地址
#示例 
# ./copyFileToAnother.sh /data/info/git/biosboot/tools/   /data/info/file/release_8.24/biosboot/
#

function getDestFilePath(){
   destpath=$2
   if [ "$2" == "" ]; then
   {
       DEST_PATH="/data/info/file"
   }
   else
   {
       DEST_PATH=$2
   }
   fi
    echo "DEST PATH is $DEST_PATH"
}

function getSrcFilePath(){
    path=$1
    if [ "${path:0:1}" == "/" ]; then
    {
        #echo "Absolute address"
        SRC_PATH=$path
    }
    elif [ "${path:0:2}" == "./" ]; then
    {
        #echo "Relative address"
        SRC_PATH=$(pwd)${path#.}
    }
    else
    {
        #echo "Short address"
        SRC_PATH="/data/info/file/release_"$path
    }
    fi
    echo "SRC_PATH is $SRC_PATH"
}

function copyTo101(){
    sshpass -p 'Yongqi@123' scp -o StrictHostKeyChecking=no -o ConnectTimeout=3 -r $SRC_PATH  root@192.168.101.240:$DEST_PATH
}

WORK_NODES=139
GENESIS_NUM=101
ALL_NODES_NUM=`expr ${WORK_NODES} + 1`

function copyToolsTo101(){
    for((i=0;i<$ALL_NODES_NUM;i++));
    do
        num=`expr 101 + $i`
        sshpass -p 'Yongqi@123' scp -o StrictHostKeyChecking=no -o ConnectTimeout=3 -r /data/info/git/biosboot/tools/*  root@192.168.101.${num}:/data/info/git/biosboot/tools/
    done
}

function copyToYamaxun(){
    scp -r -i /data/info/tafnode.pem /data/info/file/release_9.1/ ubuntu@35.72.35.95:/data/info/file
    scp -r -i /data/info/tafnode.pem /data/info/file/release_9.1/ ubuntu@35.74.78.197:/data/info/file
}

function copyToAli10(){
    scp -r -i /data/info/tafchain.pem /data/info/file/release_9.1/ root@121.41.200.60:/data/info/file
}


#getSrcFilePath $@
#getDestFilePath $@
#copyTo101
copyToolsTo101
#copyToAli10