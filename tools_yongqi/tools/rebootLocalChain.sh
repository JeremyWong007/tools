#!/bin/bash
source globalInfo.sh

CURRENT_DIR="$(cd "$(dirname "$0")"; pwd)"
cd $CURRENT_DIR

COMMAND_PATH=$0
TOOLS_PATH=${COMMAND_PATH%/*}
TOOLS_PATH=$(pwd)${TOOLS_PATH#*.}
echo "TOOLS_PATH is "${TOOLS_PATH}

cd ${TOOLS_PATH}
pkillAndWait tafcored

./unlock.sh
./ctrl_local.sh clean.sh 
./ctrl_local.sh genesis_start.sh

sleep 1
getContractPath $@
./setConfigNormal.sh $CONTRACT_PATH
./setConfigVote3.sh
./test_command.sh