#!/bin/bash
set -u
#set -x


CURRENT_DIR="$(cd "$(dirname "$0")"; pwd)"
cd $CURRENT_DIR

source globalInfo.sh

WORK_NODES=139
LOCAL_IP_BASE=101
ALL_NODES_NUM=`expr ${WORK_NODES} + 1`
TAF_MANAGE_VERSION="22.1.7"

#ALL_NODES_NUM=3
function killAllTaf(){
    for((i=0;i<$ALL_NODES_NUM;i++));
    do
        username="root"
        num=`expr ${LOCAL_IP_BASE} + $i`
        host="192.168.101.$num"
        #cmd="ps -e | grep taf | awk '{print \$1}' |xargs kill -9"
        cmd="pkill tafcored"
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
    done
    #kill ali
    #kill yamaxun
}

HostNeedStop=(
    "192.168.101.207"
    "192.168.101.209"
    "192.168.101.206"
)
function killSomeTaf(){
    for host in ${HostNeedStop[@]};
    do
        username="root"
        #cmd="ps -e | grep taf | awk '{print \$1}' |xargs kill -9"
        cmd="pkill tafcored"
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
    done
}

function reboot140(){
    cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChain.sh $TAF_MANAGE_VERSION"
    #cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr local140 --clean $TAF_MANAGE_VERSION"
    ctrolLocal140
    cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr pubYmx --clean $TAF_MANAGE_VERSION"
    ctrolYamaxun
    cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr pubAli --clean $TAF_MANAGE_VERSION"
    ctrolAli
}

function getAllAddress(){
    for((i=0;i<${#public_keys[@]};i++));
    do
        pubkey=${public_keys[i]}
        cureentAddress=$(./getAddressTool $pubkey | grep address | awk '{print $3}')
        ipnum=`expr 102 + $i`
        ip="192.168.101.$ipnum"
    echo "i=$i $pubkey $cureentAddress $ip"
    done
}

function checkHost(){
    checkHostAli
    checkHostYamaxun
    echo "echo check local 140 host"
    for((i=0;i<$ALL_NODES_NUM;i++));
    do
        username="root"
        num=`expr ${LOCAL_IP_BASE} + $i`
        host="192.168.101.$num"
        cmd="hostname"
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        #echo "result=$result"
        if [ "$result" == "" ]; then
            echo "[ERROR!!]$host cann't connect"
        elif [ "$result" == "node$num" ]; then
            #echo "$host hostname is ok"
            :
        else
            echo "[ERROR!!]$host hostname is wrong [$result]"
        fi
        
        cmd="ps -e | grep tafcored | awk '{print \$4}'"
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        if [ "$result" == "tafcored" ]; then
            echo "$host tafcored is running"
            cmd="tafclient query bcinfo | grep \"last_irreversible_block_num\""
            result=`sshpass -p "Yongqi@123" ssh  -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
            echo "$result"
        else
            echo "[ERROR!!]$host tafcored is not running"
        fi
    done
}

function checkHostAli(){
    echo "checkHostAli in"
    username="root"
    for hostname in ${!AliHostNum[@]}
    do
        host=$hostname
        cmd="ps -e | grep tafcored | awk '{print \$4}'"
        result=`ssh -i /data/info/tafchain.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        if [ "$result" == "tafcored" ]; then
            echo "$host tafcored is running"
            cmd="tafclient query bcinfo | grep \"last_irreversible_block_num\""
            result=`ssh -i /data/info/tafchain.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
            echo "$result"
        else
            echo "[ERROR!!]$host tafcored is not running"
        fi
    done
}

function checkHostYamaxun(){
    echo "checkHostYamaxun in"
    username="ubuntu"
    for hostname in ${!YamaxunHostNum[@]}
    do
        host=$hostname
        cmd="ps -e | grep tafcored | awk '{print \$4}'"
        result=`ssh -i /data/info/tafnode.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        if [ "$result" == "tafcored" ]; then
            echo "$host tafcored is running"
            cmd="tafclient query bcinfo | grep \"last_irreversible_block_num\""
            result=`ssh -i /data/info/tafnode.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
            echo "$result"
        else
            echo "[ERROR!!]$host tafcored is not running"
        fi
    done
}

function reboot140NotRun(){
    echo "reboot yamaxun not run in"
    username="ubuntu"
    for hostname in ${!YamaxunHostNum[@]}
    do
        host=$hostname
        cmd="ps -e | grep tafcored | awk '{print \$4}'"
        result=`ssh -i /data/info/tafnode.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        if [ "$result" == "tafcored" ]; then
            echo "$host tafcored is running"
        else
            #echo "[ERROR!!]  tafcored is not running"
            cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr pubYmx --clean"
            result=`ssh -i /data/info/tafnode.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        
            cmd="ps -e | grep tafcored | awk '{print \$4}'"
            result=`ssh -i /data/info/tafnode.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
            if [ "$result" == "tafcored" ]; then
                echo "$host taf chain reboot ok"
            else
                echo "[ERROR!!] $host taf chain reboot error"
            fi
        fi
    done

    echo "reboot local140 not run in"
    for((i=0;i<$ALL_NODES_NUM;i++));
    do
        username="root"
        num=`expr ${LOCAL_IP_BASE} + $i`
        host="192.168.101.$num"
        cmd="ps -e | grep tafcored | awk '{print \$4}'"
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        if [ "$result" == "tafcored" ]; then
            echo "$host tafcored is running"
        else
            #echo "[ERROR!!]  tafcored is not running"
            cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChain.sh"
            result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        
            cmd="ps -e | grep tafcored | awk '{print \$4}'"
            result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
            if [ "$result" == "tafcored" ]; then
                echo "$host taf chain reboot ok"
            else
                echo "[ERROR!!] $host taf chain reboot error"
            fi
        fi
    done
}

function ctrl140After16NotRun(){
    echo "ctrl140After16NotRun in"
    for((i=16;i<$ALL_NODES_NUM;i++));
    do
    {
        username="root"
        num=`expr ${LOCAL_IP_BASE} + $i`
        host="192.168.101.$num"
        cmdIn="ps -e | grep tafcored | awk '{print \$4}'"
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmdIn`
        if [ "$result" == "tafcored" ]; then
            echo "$host tafcored is running"
        else
            #echo "[ERROR!!]  tafcored is not running"
            #cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChain.sh"
            result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
            echo $host $result
        fi
    }&
    done
    wait
    echo "ctrl140After16NotRun out"
}

function copyPemTo140_Yamaxun(){
    echo "copyPemTo140_Yamaxun in"
    username="ubuntu"
    for hostname in ${!YamaxunHostNum[@]}
    do
        host=$hostname
        scp -r -i /data/info/tafnode.pem /data/info/tafnode.pem ubuntu@$host:/data/info/
        echo "$host copy pem ok"
    done
}

function copyFileToYamaxunOne(){
    echo "copyFileToYamaxunOne in"
    username="ubuntu"
    scp -r -i /data/info/tafnode.pem  -o StrictHostKeyChecking=no -o ConnectTimeout=10 $COPY_FILE_SRC ubuntu@$oneYamaxunHost:$COPY_FILE_DEST
}

function copyFileToYamaxun(){
    echo "copyFileToYamaxun in"
    username="ubuntu"
    scp -r -i /data/info/tafnode.pem  -o StrictHostKeyChecking=no -o ConnectTimeout=10 $COPY_FILE_SRC $username@13.230.34.236:$COPY_FILE_DEST
    echo "file has copy to 13.230.34.236"

    for hostname in ${!YamaxunHostNum[@]}
    do
        #“13.230.34.236”对应内网ip为“172.31.21.227”
        if [ $hostname == "13.230.34.236" ]; then
            echo "it's $hostname"
            continue
        fi
        host=$hostname
        cmd="scp -r -i /data/info/tafnode.pem  -o StrictHostKeyChecking=no -o ConnectTimeout=10 ubuntu@172.31.21.227:$COPY_FILE_SRC $COPY_FILE_DEST"
        result=`ssh -i /data/info/tafnode.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    done
}

function copyFileToYamaxunBx(){
    echo "copyFileToYamaxunBx in"
    username="ubuntu"
    scp -r -i /data/info/tafnode.pem  -o StrictHostKeyChecking=no -o ConnectTimeout=10 $COPY_FILE_SRC $username@13.230.34.236:$COPY_FILE_DEST
    echo "file has copy to 13.230.34.236"

    for hostname in ${!YamaxunHostNum[@]}
    do
    {
        #“13.230.34.236”对应内网ip为“172.31.21.227”
        if [ $hostname == "13.230.34.236" ]; then
            echo "it's $hostname"
            continue
        fi
        host=$hostname
        cmd="scp -r -i /data/info/tafnode.pem  -o StrictHostKeyChecking=no -o ConnectTimeout=10 ubuntu@172.31.21.227:$COPY_FILE_SRC $COPY_FILE_DEST"
        result=`ssh -i /data/info/tafnode.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    }&
    done
    wait
    echo "copyFileToYamaxunBx out"
}

function copyFileToAli(){
    echo "copyFileToAli in"
    username="root"
    scp -r -i /data/info/tafchain.pem $COPY_FILE_SRC root@121.41.193.65:$COPY_FILE_DEST
    #121.41.193.65对应局域网IP：192.168.4.68
    echo "file has copy to 121.41.193.65"
    for hostname in ${!AliHostNum[@]}
    do
        if [ $hostname == "121.41.193.65" ]; then
            echo "it's $hostname"
            continue
        fi
        host=$hostname
        cmd="scp -r -i /data/info/tafchain.pem root@192.168.4.68:$COPY_FILE_SRC $COPY_FILE_DEST"
        result=`ssh -i /data/info/tafchain.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host"
    done
}

function copyFileToAliBx(){
    echo "copyFileToAliBx in"
    username="root"
    scp -r -i /data/info/tafchain.pem $COPY_FILE_SRC root@121.41.193.65:$COPY_FILE_DEST
    #121.41.193.65对应局域网IP：192.168.4.68
    echo "file has copy to 121.41.193.65"
    for hostname in ${!AliHostNum[@]}
    do
    {
        if [ $hostname == "121.41.193.65" ]; then
            echo "it's $hostname"
            continue
        fi
        host=$hostname
        cmd="scp -r -i /data/info/tafchain.pem root@192.168.4.68:$COPY_FILE_SRC $COPY_FILE_DEST"
        result=`ssh -i /data/info/tafchain.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host"
    }&
    done
    wait
    echo "copyFileToAliBx out"
}

function copyFileToLocal140(){
    echo "copyFileToLocal140 in"
    for((i=0;i<$ALL_NODES_NUM;i++));
    do
        num=`expr 101 + $i`
        sshpass -p 'Yongqi@123' scp -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r $COPY_FILE_SRC  root@192.168.101.${num}:$COPY_FILE_DEST
        echo "192.168.101.${num}"
    done
}

function copyFileToLocal140Bx(){
    echo "copyFileToLocal140Bx in"
    for((i=0;i<$ALL_NODES_NUM;i++));
    do
    {
        num=`expr 101 + $i`
        sshpass -p 'Yongqi@123' scp -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r $COPY_FILE_SRC  root@192.168.101.${num}:$COPY_FILE_DEST
        echo "192.168.101.${num}"
    }&
    done
    wait
    echo "copyFileToLocal140Bx out"
}
function copyFileToLocal140Bx2(){
    echo "copyFileToLocal140Bx2 in"
    username="root"
    for((i=0;i<$ALL_NODES_NUM;i++));
    do
    {
        gewei=`expr $i % 10`
        if [ $gewei != "0" ]; then
            continue
        fi
        num=`expr 101 + $i`
        sshpass -p 'Yongqi@123' scp -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r $COPY_FILE_SRC  root@192.168.101.${num}:$COPY_FILE_DEST
        echo "first copy to 192.168.101.${num}"
    }&
    done
    wait
    
    for((i=0;i<$ALL_NODES_NUM;i++));
    do
    {
        gewei=`expr $i % 10`
        if [ $gewei == "0" ]; then
            continue
        fi
        num=`expr ${LOCAL_IP_BASE} + $i`
        base_num=`expr ${num} - $gewei`
        host="192.168.101.$num"
        cmd="sshpass -p 'Yongqi@123' scp -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r root@192.168.101.$base_num:$COPY_FILE_SRC $COPY_FILE_DEST"
        echo "cmd is: $cmd"
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "Next copy to $host"
    }&
    done
    wait
    echo "copyFileToLocal140Bx2 out"
}

function copyFileToLocalFirst16Bx(){
    echo "copyFileToLocalFirst16Bx in"
    for((i=0;i<16;i++));
    do
    {
        num=`expr 101 + $i`
        sshpass -p 'Yongqi@123' scp -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r $COPY_FILE_SRC  root@192.168.101.${num}:$COPY_FILE_DEST
        echo "192.168.101.${num}"
    }&
    done
    wait
    echo "copyFileToLocalFirst16Bx out"
}

function ctrolYamaxun(){
    echo "ctrolYamaxun in"
    username="ubuntu"
    for hostname in ${!YamaxunHostNum[@]}
    do
        if [ $hostname == "35.72.35.95" ]; then
            echo "it's $hostname"
            continue
        fi
        if [ $hostname == "35.74.78.197" ]; then
            echo "it's $hostname"
            continue
        fi
        host=$hostname
        setCmd
        result=`ssh -i /data/info/tafnode.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    done
}

function ctrolYamaxunBx(){
    echo "ctrolYamaxunBx in"
    username="ubuntu"
    for hostname in ${!YamaxunHostNum[@]}
    do
    {
        host=$hostname
        setCmd
        result=`ssh -i /data/info/tafnode.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    }&
    done
    wait
    echo "ctrolYamaxunBx out"
}


declare -A YamaxunHostNumPart1
YamaxunHostNumPart1["13.230.34.236"]=${YamaxunHostNum["13.230.34.236"]}
YamaxunHostNumPart1["18.176.224.246"]=${YamaxunHostNum["18.176.224.246"]}
YamaxunHostNumPart1["18.180.156.94"]=${YamaxunHostNum["18.180.156.94"]}
YamaxunHostNumPart1["35.77.32.87"]=${YamaxunHostNum["35.77.32.87"]}
YamaxunHostNumPart1["35.75.22.237"]=${YamaxunHostNum["35.75.22.237"]}
YamaxunHostNumPart1["18.183.203.208"]=${YamaxunHostNum["18.183.203.208"]}
YamaxunHostNumPart1["3.112.63.128"]=${YamaxunHostNum["3.112.63.128"]}
YamaxunHostNumPart1["35.72.35.95"]=${YamaxunHostNum["35.72.35.95"]}
YamaxunHostNumPart1["35.74.253.51"]=${YamaxunHostNum["35.74.253.51"]}
YamaxunHostNumPart1["35.74.78.197"]=${YamaxunHostNum["35.74.78.197"]}
YamaxunHostNumPart1["35.76.107.8"]=${YamaxunHostNum["35.76.107.8"]}

declare -A YamaxunHostNumPart2
YamaxunHostNumPart2["3.115.1.53"]=${YamaxunHostNum["3.115.1.53"]}

function ctrolYamaxunBxPart1(){
    echo "ctrolYamaxunBxPart1 in"
    username="ubuntu"
    for hostname in ${!YamaxunHostNumPart1[@]}
    do
    {
        host=$hostname
        setCmd
        result=`ssh -i /data/info/tafnode.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    }&
    done
    wait
    echo "ctrolYamaxunBxPart1 out"
}

function ctrolYamaxunBxPart2(){
    echo "ctrolYamaxunBxPart2 in"
    username="ubuntu"
    for hostname in ${!YamaxunHostNumPart2[@]}
    do
    {
        host=$hostname
        setCmd
        result=`ssh -i /data/info/tafnode.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    }&
    done
    wait
    echo "ctrolYamaxunBxPart2 out"
}

function ctrolAli(){
    echo "ctrolAli in"
    username="root"
    for hostname in ${!AliHostNum[@]}
    do
        host=$hostname
        setCmd
        result=`ssh -i /data/info/tafchain.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    done
}

function ctrolAliBx(){
    echo "ctrolAliBx in"
    username="root"
    for hostname in ${!AliHostNum[@]}
    do
    {
        host=$hostname
        setCmd
        result=`ssh -i /data/info/tafchain.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    }&
    done
    wait
    echo "ctrolAliBx out"
}

declare -A AliHostNumPart1
AliHostNumPart1["121.41.199.36"]=${AliHostNum["121.41.199.36"]}
AliHostNumPart1["121.41.199.39"]=${AliHostNum["121.41.199.39"]}
function ctrolAliPart1Bx(){
    echo "ctrolAliPart1Bx in"
    username="root"
    for hostname in ${!AliHostNumPart1[@]}; 
    do
    {
        host=$hostname
        setCmd
        result=`ssh -i /data/info/tafchain.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    }&
    done
    wait
    echo "ctrolAliPart1Bx out"
}

declare -A AliHostNumPart2
AliHostNumPart2["121.41.193.65"]=${AliHostNum["121.41.193.65"]}
AliHostNumPart2["121.41.197.161"]=${AliHostNum["121.41.197.161"]}
AliHostNumPart2["121.41.197.238"]=${AliHostNum["121.41.197.238"]}
AliHostNumPart2["121.41.197.97"]=${AliHostNum["121.41.197.97"]}
function ctrolAliPart2(){
    echo "ctrolAliPart2 in"
    username="root"
    for hostname in ${!AliHostNumPart2[@]}
    do
        host=$hostname
        setCmd
        result=`ssh -i /data/info/tafchain.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    done
}
function ctrolAliPart2Bx(){
    echo "ctrolAliPart2Bx in"
    username="root"
    for hostname in ${!AliHostNumPart2[@]}; 
    do
    {
        host=$hostname
        setCmd
        result=`ssh -i /data/info/tafchain.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    }&
    done
    wait
    echo "ctrolAliPart2 out"
}
function ctrolAliPart2NotrunBx(){
    echo "ctrolAliPart2NotrunBx in"
    username="root"
    for hostname in ${!AliHostNumPart2[@]}; 
    do
    {
        host=$hostname
        cmdIn="ps -e | grep tafcored | awk '{print \$4}'"
        result=`ssh -i /data/info/tafchain.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmdIn`
        if [ "$result" == "tafcored" ]; then
            echo "$host tafcored is running"
        else
            setCmd
            result=`ssh -i /data/info/tafchain.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
            echo "$host $result"
        fi
    }&
    done
    wait
    echo "ctrolAliPart2NotrunBx out"
}
function ctrolLocal140(){
    echo "ctrolLocal140 in"
    for((i=0;i<$ALL_NODES_NUM;i++));
    do
        username="root"
        num=`expr ${LOCAL_IP_BASE} + $i`
        host="192.168.101.$num"
        setCmd
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    done
}

function ctrolLocal140Bx(){
    echo "ctrolLocal140Bx in"
    for((i=0;i<$ALL_NODES_NUM;i++));
    do
    {
        username="root"
        num=`expr ${LOCAL_IP_BASE} + $i`
        host="192.168.101.$num"
        setCmd
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    }&
    done
    wait
    echo "ctrolLocal140Bx out"
}

function ctrolLocalOne(){
    echo "ctrolLocalOne in"
    username="root"
    num=101
    host="192.168.101.$num"
    setCmd
    result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
    echo "$host $result"
    echo "ctrolLocalOne out"
}

function ctrolLocal140After16Bx(){
    echo "ctrolLocal140After16Bx in"
    for((i=16;i<$ALL_NODES_NUM;i++));
    do
    {
        username="root"
        num=`expr ${LOCAL_IP_BASE} + $i`
        host="192.168.101.$num"
        setCmd
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    }&
    done
    wait
    echo "ctrolLocal140After16Bx out"
}

function ctrolLocal140Tmp(){
    echo "ctrolLocal140Tmp in"
    for((i=16;i<32;i++));
    do
        username="root"
        num=`expr ${LOCAL_IP_BASE} + $i`
        host="192.168.101.$num"
        setCmd
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    done
}

function ctrolLocalFirst16(){
    echo "ctrolLocalFirst16 in"
    for((i=0;i<16;i++));
    do
        username="root"
        num=`expr ${LOCAL_IP_BASE} + $i`
        host="192.168.101.$num"
        setCmd
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    done
}

function ctrolLocalFirst16Bx(){
    echo "ctrolLocalFirst16Bx in"
    for((i=0;i<16;i++));
    do
    {
        username="root"
        num=`expr ${LOCAL_IP_BASE} + $i`
        host="192.168.101.$num"
        setCmd
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    }&
    done
    wait
    echo "ctrolLocalFirst16Bx out"
}

function ctrolLocalFirst16NotrunBx(){
    echo "ctrolLocalFirst16NotrunBx in"
    for((i=0;i<16;i++));
    do
    {
        username="root"
        num=`expr ${LOCAL_IP_BASE} + $i`
        host="192.168.101.$num"
        cmdIn="ps -e | grep tafcored | awk '{print \$4}'"
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmdIn`
        if [ "$result" == "tafcored" ]; then
            echo "$host tafcored is running"
        else
            #echo "[ERROR!!]  tafcored is not running"
            #cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChain.sh"
            result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
            echo $host $result
        fi
    }&
    done
    wait
    echo "ctrolLocalFirst16NotrunBx out"
}

function ctrolPart2(){
    ctrolLocalFirst16Bx
    ctrolYamaxunBxPart2
    ctrolAliPart2Bx
}

#本地链管理
function ctrolLocal1Bx(){
    echo "ctrolLocal1Bx in"
    for hostname in ${!Local1[@]}
    do
    {
        username=${Local1UserName[${hostname}]}
        host=$hostname
        setCmd
        result=`sshpass -p "yongqi001" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    }&
    done
    wait
    echo "ctrolLocal1Bx out"
}

function copyFileToLocal1(){
    echo "copyFileToLocal1 in"
    for hostname in ${!Local1[@]}
    do
    {
        username=${Local1UserName[${hostname}]}
        sshpass -p 'yongqi001' scp -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r $COPY_FILE_SRC  $username@$hostname:$COPY_FILE_DEST
        echo $hostname
    }&
    done
    wait
    echo "copyFileToLocal1 out"
}

function copyFileToLocalHostV2(){
    echo "copyFileToLocalHostV2 in"
    for hostname in ${!LocalHostV2Num[@]}
    do
    {
        username=root
        sshpass -p 'Yongqi@123' scp -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r $COPY_FILE_SRC  $username@$hostname:$COPY_FILE_DEST
        echo $hostname
    }&
    done
    wait
    echo "copyFileToLocalHostV2 out"
}

accounts=(
    "T1Gygra5GoPAg5cAN6g7CKbPsLFmrJvSyXo"
    "T16ir91JVZS23Vy5aJy5bpaQmoRs4458jwF"
    "T1Ho9auzEV4ZxNadJ3mbvKC9GZHkZw3aMzw"
    "T138rgrQG3v9XdwUyQk79yFFKd7LpBAMGDa"
    "T17mBpBndyur5P7mtiF8ui8XtBxr4HTsCKh"
    "T164oq8K88wnLsbg8tGRZtM5KAxGvXXs7BS"
    "T1JQRCRbe7PwqGc93S586DBr2TqxFFeUAeB"
    "T134kZ5f6qBfJFJDKpRHAf6ZLLwfFXrnmeo"
    "T1F3EnJjzv91NqfTeK9HaQS7PvhHXz2aRaQ"
    "T16PMDzwLyPvoMiMZe746kAebEMT9nibL8j"
    "T13GAb7FhWRxxfQxZL94NdgnRReWSP7CUPz"
    "T19ee7gptkZ2H4bMbGt5CcfEpd1REbGuDMo"
    "T1PJYoqMwqKwNqbyo74SSkQetCaw9ZDWmKc"
    "T13gH6vUDQyBwcFC1MrkgNuePUh88yifbwr"
    "T1D7QALzER3tF9qs1hYFZaf93Uo7omr2p8Q"
    "T12EXMWBZnufveKQLB29FXdo8J3goq9w65v"
    "T12Wd8ZvxqhwSRkFciYA9ixVrCZCRJh4N1a"
    "T14BUGQiBk7HCtkyNn86JQuHW5R5HHLJQdg"
    "T1JRs7qxV53hrEMQBhCkabJeWj1tcb8Jqpv"
    "T1933YsZg5jCq9nZUSGgDfkyntCYxn8yJvQ"
    "T1MQwUpKmZG48LKNhJ4oafMFoHZ5GFV4Wb8"
)
function getNodeNum(){

    for acc in ${accounts[@]}; do
        for((i=0;i<${#pub_accounts[@]};i++)); do
            if [ $acc == ${pub_accounts[$i]} ]
            then
                echo "$acc's node num: $i"
            fi
        done
    done
}

#对应缩小后的小网络，内部测试网
function ctrolLocalV2Bx(){
    echo "ctrolLocalV2Bx in"
    username="root"
    for hostname in ${!LocalHostV2Num[@]}
    do
    {
        host=$hostname
        setCmd
        result=`sshpass -p "Yongqi@123" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$host $cmd`
        echo "$host $result"
    }&
    done
    wait
    echo "ctrolLocalV2Bx out"
}

function setCmd(){
    #cmd="echo \"TAF_NODE_NUM=$i\" > /data/info/env.taf;cat /data/info/env.taf"
    #cmd="echo \"TAF_NODE_NUM=${AliHostNum[$hostname]}\" > /data/info/env.taf;cat /data/info/env.taf"
    #cmd="echo \"TAF_NODE_NUM=${YamaxunHostNum[$hostname]}\" > /data/info/env.taf;cat /data/info/env.taf"
    #cmd="echo \"TAF_NODE_NUM=${Local1[$hostname]}\" > /data/info/env.taf;cat /data/info/env.taf"
    #cmd="echo \"TAF_NODE_NUM=${LocalHostV2Num[$hostname]}\" > /data/info/env.taf;cat /data/info/env.taf"
    :
}
#cmd="ps -e | grep taf | awk '{print \$1}' |xargs kill -9"
#cmd="pkill tafcored; pkill tafwalletd"
#cmd="pkill tafwalletd"
#cmd="ps -e | grep taf"
#cmd="ulimit -s | grep 1"
#cmd="rm ~/tafsys-wallet/default.wallet"
#cmd="cd /data/info/file/release_${TAF_MANAGE_VERSION}/biosboot/tools;./unlock.sh"
#cmd="ulimit -s 102400; /data/info/test/test"
#cmd="sudo mkdir -p /data/info/file;sudo chmod 777 -R /data"
#cmd="scp -r -i /data/info/tafnode.pem  -o StrictHostKeyChecking=no -o ConnectTimeout=10 ubuntu@172.31.21.227:/data/info/file/release_${TAF_MANAGE_VERSION}/ /data/info/file/"
#cmd="sudo dpkg -r tafsys;sudo dpkg -i /data/info/file/release_${TAF_MANAGE_VERSION}/tafSoftware_0.0.1.deb"
#cmd="echo Yongqi@123 | sudo -S dpkg -r tafsys;sudo dpkg -i /data/info/file/release_${TAF_MANAGE_VERSION}/tafSoftware_0.0.1.deb"
#cmd="ps -e | grep tafcored | awk '{print \$4}'"
#cmd="rm -rf /data/info/file/release_7.21"
#cmd="rm -rf /data/biosboot/pubchain"
#cmd="apt install sshpass"
##cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr v3 --clean"
#cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr v3"
#cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr v3 --hardReplay"
#cmd="ulimit -s 102400; cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr v3"
#cmd="ulimit -s 102400; cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr v4"
#cmd="ulimit -s 102400; cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr v5"
##cmd="rm -rf /data/biosboot/pubchain"
#cmd="cd /data/info/file/release_10.14/biosboot/tools;./rebootReleaseChain.sh"
##cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr local140 --clean"
##cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr localv2 --clean"
#cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr localv2"
#ctrolLocal140
#ctrolLocal140Bx
#ctrolLocalFirst16
#ctrolLocalFirst16Bx
#ctrolLocalFirst16NotrunBx
#ctrolLocal140After16Bx
#ctrolLocal140Tmp
#ctrl140After16NotRun
#ctrolLocalOne
##cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr pubYmx --clean"
##cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr pubv2 --clean"
#cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr pubv2"
#ctrolYamaxun
#ctrolYamaxunBx
#ctrolYamaxunBxPart1
#ctrolYamaxunBxPart2
##cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr pubAli --clean"
##cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr pubv2 --clean"
#cmd="cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChainNew.sh --p2pAddr pubv2"
#ctrolAli
#ctrolAliBx
#ctrolAliPart2
#ctrolAliPart2Bx
#ctrolAliPart2NotrunBx
#ctrolAliPart1Bx
#killSomeTaf
#ctrolPart2
#ctrolLocalV2Bx

#cmd="source /etc/profile; cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChain.sh --p2pAddr v1"
#cmd="source /etc/profile; cd /data/info/file/release_$TAF_MANAGE_VERSION/biosboot/tools;./rebootReleaseChain.sh --p2pAddr v1 --clean"
#ctrolLocal1Bx

function copyLocalToRelease(){
    #COPY_FILE_SRC_LOCAL="/data/info/git/biosboot/tools/*"
    #COPY_FILE_SRC_LOCAL="/data/info/git/biosboot/*"
    COPY_FILE_SRC_LOCAL="/data/info/git/biosboot/tools/rebootReleaseChainNew.sh"
    COPY_FILE_DEST="/data/info/file/release_${TAF_MANAGE_VERSION}/biosboot/tools/"
    #COPY_FILE_DEST="/data/info/file/release_${TAF_MANAGE_VERSION}/biosboot/"
    cp -rf $COPY_FILE_SRC_LOCAL $COPY_FILE_DEST #注意，源路径需与目标路径一致
}
#copyLocalToRelease

#COPY_FILE_SRC="/data/info/file/release_${TAF_MANAGE_VERSION}/"
#COPY_FILE_DEST="/data/info/file/"
#COPY_FILE_SRC="/etc/profile"
#COPY_FILE_DEST="/etc/"
#COPY_FILE_SRC="/data/info/file/release_${TAF_MANAGE_VERSION}/contracts"
#COPY_FILE_SRC="/data/info/file/release_${TAF_MANAGE_VERSION}/test/*"
#COPY_FILE_DEST="/data/info/file/release_${TAF_MANAGE_VERSION}/test/"
#COPY_FILE_SRC="/data/info/file/release_${TAF_MANAGE_VERSION}/biosboot/tools/setConfig.sh"
#COPY_FILE_SRC="/data/info/file/release_${TAF_MANAGE_VERSION}/biosboot/tools/rebootReleaseChainNew.sh"
#COPY_FILE_SRC="/data/info/file/release_${TAF_MANAGE_VERSION}/biosboot/tools/rebootReleaseChain.sh"
#COPY_FILE_SRC="/data/info/file/release_${TAF_MANAGE_VERSION}/biosboot/tools/ctrlChain.sh"
#COPY_FILE_SRC="/data/info/file/release_${TAF_MANAGE_VERSION}/biosboot/tools/*"
#COPY_FILE_SRC="/data/info/file/release_${TAF_MANAGE_VERSION}/biosboot/genesis3.json"
#COPY_FILE_DEST="/data/info/file/release_${TAF_MANAGE_VERSION}/biosboot/tools/"
#COPY_FILE_DEST="/data/info/file/release_${TAF_MANAGE_VERSION}/biosboot/"
#copyFileToLocal140Bx2
#copyFileToLocalFirst16Bx
#copyFileToAliBx
#copyFileToYamaxunBx
#oneYamaxunHost="3.115.1.53"
#copyFileToYamaxunOne
#copyFileToLocal1
#copyFileToLocalHostV2

function copyAndInstall140(){
    echo "copyAndInstall140 in"
    COPY_FILE_SRC="/data/info/file/release_${TAF_MANAGE_VERSION}/"
    COPY_FILE_DEST="/data/info/file/"
    copyFileToLocal140
    copyFileToAli
    copyFileToYamaxun

    cmd="sudo dpkg -r tafsys;sudo dpkg -i /data/info/file/release_${TAF_MANAGE_VERSION}/tafSoftware_0.0.1.deb"
    ctrolLocal140
    ctrolYamaxun
    ctrolAli
}

function usage() {
    echo "Usage:"
    echo " getopt <optstring> <parameters>"
    echo ""
    echo "Exapmple:"
    echo " ./ctrlServers.sh --killall"
    echo " ./ctrlServers.sh --copyAndInstall140"
    echo " ./ctrlServers.sh --reboot140"
    echo " ./ctrlServers.sh --reboot140NotRun"
    echo " ./ctrlServers.sh --getaddr"
    echo " ./ctrlServers.sh --checkHost"
    exit 1
}

ARGS=`getopt -o h --long killall,getaddr,reboot140::,,checkHost,reboot140NotRun,copyAndInstall140 -n 'ctrlServers.sh' -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

#将规范化后的命令行参数分配至位置参数（$1,$2,...)
eval set -- "${ARGS}"
while true
do
    case "$1" in
        --killall)
            echo "kill all in"
            killAllTaf
            shift
            ;;
        --copyAndInstall140)
            copyAndInstall140
            shift
            ;;
        --reboot140NotRun)
            echo "reboot140NotRun in"
            reboot140NotRun
            shift
            ;;
        --reboot140)
        #示例：
        #./ctrlServers.sh --reboot140 全部启动
        #./ctrlServers.sh --reboot140=20 启动前20个节点
            case "$2" in
                "")
                    reboot140
                    shift 2
                    ;;
                *)
                    ALL_NODES_NUM=$2
                    echo "rebootReleaseChain $2"
                    reboot140
                    shift 2
                    ;;
            esac
            ;;
        --checkHost)
            checkHost
            shift
            ;;
        --getaddr)
            echo "getaddr in"
            getAllAddress
            shift
            ;;
        --)
            shift
            break
            ;;
        -h)
            usage
            ;;
        *)
            echo "Internal error!"
            exit 1
            ;;
    esac
done

