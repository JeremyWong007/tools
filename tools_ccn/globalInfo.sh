#！/bin/bash

function getContractPath(){
    path=$1
    if [ "${path:0:1}" == "/" ]; then
    {
        #echo "Absolute address"
        CONTRACT_PATH=$path
    }
    elif [ "${path:0:2}" == "./" ]; then
    {
        #echo "Relative address"
        CONTRACT_PATH=$(pwd)${path#.}
    }
    elif [ "$path" == "" ]; then
    {
        #echo "Default address"
        CONTRACT_PATH="/data/info/git/contracts/build/contracts/"
    }
    else
    {
        #echo "Short address"
        CONTRACT_PATH="/data/info/file/release_${path}/contracts/"
    }
    fi
    echo "CONTRACT_PATH is $CONTRACT_PATH"
}

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
    return -1
}

