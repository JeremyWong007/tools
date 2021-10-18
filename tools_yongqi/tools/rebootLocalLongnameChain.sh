#!/bin/bash
set -u

version=$1
COMMAND_PATH=$0
TOOLS_PATH=${COMMAND_PATH%/*}
TOOLS_PATH=$(pwd)${TOOLS_PATH#*.}
echo "TOOLS_PATH is "${TOOLS_PATH}

cd ${TOOLS_PATH}
pkill tafcored
sleep 0.1

./unlock.sh
./ctrl_localLongname.sh clean.sh 
./ctrl_localLongname.sh genesis_start.sh
sleep 1
./setConfigNormal.sh /data/info/file/release_${version}/contracts/
./setConfigVote3_Longname.sh
./test_command.sh