#!/bin/bash

#校验default钱包

tafclient wallet open
tafclient wallet open #执行两次，防止第一次执行时提示“Unable to connect to tafwalletd, if tafwalletd is running please kill the process and try again.”
result=$(tafclient wallet list | grep \"default)
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
