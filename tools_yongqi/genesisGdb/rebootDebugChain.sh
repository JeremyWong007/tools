#!/bin/bash
set -u
set -x

version=$1
COMMAND_PATH=$0
TOOLS_PATH=${COMMAND_PATH%/*}
TOOLS_PATH=$(pwd)${TOOLS_PATH#*.}
echo "TOOLS_PATH is "${TOOLS_PATH}

cd ${TOOLS_PATH}
pkill tafcored
sleep 0.1

../tools/unlock.sh
./clean.sh 
./genesis_start.sh
sleep 1
./setConfigNormal.sh /data/info/file/release_${version}/contracts/
#./setConfigVote3.sh
#./test_command.sh