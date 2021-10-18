#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "$0")"; pwd)"
cd $CURRENT_DIR

echo $#
if [ $# == 0 ];
then
    version="default"
else
    version=$1
fi
COMMAND_PATH=$0
TOOLS_PATH=${COMMAND_PATH%/*}
TOOLS_PATH=$(pwd)${TOOLS_PATH#*.}
echo "TOOLS_PATH is "${TOOLS_PATH}

cd ${TOOLS_PATH}
killall tafcored
sleep 0.1

./unlock.sh
./ctrl_local.sh clean.sh 
./ctrl_local.sh genesis_start.sh
sleep 1
if [ ${version} == "default" ]; 
then
    ./setConfigNormal.sh /data/info/git/contracts/build/contracts/
else
    ./setConfigNormal.sh /data/info/file/release_${version}/contracts/
fi
./setConfigVote3.sh
./test_command.sh