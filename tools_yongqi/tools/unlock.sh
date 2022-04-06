#!/bin/bash

#校验default钱包

function pkillAndWait(){
    threadName=$1
    pkill $threadName
    sleep 0.5
    for((i=0;i<300;i++))
    do
        result=`ps -e | grep $threadName | awk '{print \$4}'`
        if [ "$result" != "$threadName" ]; then
            echo "kill ok $threadName"
            return 0
        fi
        echo "kill again $i"
        pkill $threadName
        sleep 1
    done
    echo "Fail to kill $threadName"
    exit
}

function runAndWait(){
    cmd=$1
    eval $cmd
    for((i=0;i<300;i++))
    do
        eval $cmd
        if [ "$result" != "$threadName" ]; then
            echo "kill ok $threadName"
            return 0
        fi
        echo "kill again $i"
        pkill $threadName
        sleep 1
    done
    echo "Fail to kill $threadName"
    exit
}

 #kill掉，防止第一次执行时提示“Unable to connect to tafwalletd, if tafwalletd is running please kill the process and try again.”
pkillAndWait tafwalletd
tafclient wallet open
result=`tafclient wallet open -n default`
if [ "$result" == "" ]
then
    #判断/data/info文件夹是否存在
    if [[ ! -d "/data/info" ]]; then
        mkdir -p /data/info
        echo "create file path: /data/info"
    fi
    tafclient wallet new -f /data/info/wallet.key
    echo "wallet default is created."
else
    echo "wallet default is exit"
fi

key=$(cat /data/info/wallet.key)
tafclient wallet unlock --password $key
