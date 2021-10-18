#!/bin/bash
#set -u
#set -x

source globalInfo.sh
function correctNum(){
    if [ $NUM_TMP -lt 101 ]; then
        NUM_TMP=`expr 240 - 100 + $NUM_TMP`
    elif [ $NUM_TMP -gt 240 ]; then
        NUM_TMP=`expr $NUM_TMP - 240 + 100`
    fi
}
function setCommand(){
    NUM_TMP=`expr $num - 1`
    correctNum
    numb1=$NUM_TMP
    NUM_TMP=`expr $num - 2`
    correctNum
    numb2=$NUM_TMP
    NUM_TMP=`expr $num - 3`
    correctNum
    numb3=$NUM_TMP
    NUM_TMP=`expr $num - 4`
    correctNum
    numb4=$NUM_TMP
    NUM_TMP=`expr $num - 5`
    correctNum
    numb5=$NUM_TMP
    NUM_TMP=`expr $num + 1`
    correctNum
    num1=$NUM_TMP
    NUM_TMP=`expr $num + 2`
    correctNum
    num2=$NUM_TMP
    NUM_TMP=`expr $num + 3`
    correctNum
    num3=$NUM_TMP
    NUM_TMP=`expr $num + 4`
    correctNum
    num4=$NUM_TMP
    NUM_TMP=`expr $num + 5`
    correctNum
    num5=$NUM_TMP
    NUM_TMP=`expr $num + 32`
    correctNum
    numj1=$NUM_TMP
    NUM_TMP=`expr $num + 48`
    correctNum
    numj2=$NUM_TMP
    NUM_TMP=`expr $num + 64`
    correctNum
    numj3=$NUM_TMP
    NUM_TMP=`expr $num + 80`
    correctNum
    numj4=$NUM_TMP
    NUM_TMP=`expr $num + 96`
    correctNum
    numj5=$NUM_TMP
    echo "show num: $numb5 $numb4 $numb3 $numb2 $numb1 $num1 $num2 $num3 $num4 $num5 $numj1 $numj2 $numj3 $numj4 $numj5"
    
    CMD="tafcored \
    --plugin tafsys::maker_plugin \
    --plugin tafsys::maker_api_plugin \
    --plugin tafsys::chain_plugin \
    --plugin tafsys::chain_api_plugin \
    --plugin tafsys::http_plugin \
    --plugin tafsys::history_api_plugin \
    --plugin tafsys::history_plugin \
    --data-dir $DATADIR"/data" \
    --blocks-dir $DATADIR"/blocks" \
    --config-dir $DATADIR"/config" \
    --access-control-allow-origin=* \
    --contracts-console \
    --http-validate-host=false \
    --verbose-http-errors \
    --enable-stale-production \
    --abi-serializer-max-time-ms 1000000 \
    --http-max-response-time-ms 500 \
    --max-transaction-time 1000 \
    --tafwalletd-provider-timeout 5000 \
    --p2p-max-nodes-per-host 100 \
    --chain-state-db-size-mb=102400 \
    --genesis-json "../genesis101.json" \
    --logconf=../logging.json \
    --http-server-address 0.0.0.0:$HTTP_LISTEN_PORT \
    --p2p-listen-endpoint 0.0.0.0:$P2P_LISTEN_PORT \
    --p2p-peer-address 192.168.101.$num1:9010 \
    --p2p-peer-address 192.168.101.$num2:9010 \
    --p2p-peer-address 192.168.101.$num3:9010 \
    --p2p-peer-address 192.168.101.$num4:9010 \
    --p2p-peer-address 192.168.101.$num5:9010 \
    --p2p-peer-address 192.168.101.$numb1:9010 \
    --p2p-peer-address 192.168.101.$numb2:9010 \
    --p2p-peer-address 192.168.101.$numb3:9010 \
    --p2p-peer-address 192.168.101.$numb4:9010 \
    --p2p-peer-address 192.168.101.$numb5:9010 \
    --p2p-peer-address 192.168.101.$numj1:9010 \
    --p2p-peer-address 192.168.101.$numj2:9010 \
    --p2p-peer-address 192.168.101.$numj3:9010 \
    --p2p-peer-address 192.168.101.$numj4:9010 \
    --p2p-peer-address 192.168.101.$numj5:9010 \
    --maker-name $NAME \
    --signature-provider $PROVIDER \
    >> $DATADIR"/tafcored.log" 2>&1 & "
    #echo $! > $DATADIR"/tafd.pid" "
}

function cleanRoom(){
    rm -rf "/data/biosboot/pubchain"
    sleep 0.1
}

pkill tafcored
sleep 0.1
#cleanRoom
getContractPath $@

#打开钱包
./unlock.sh

BASE_DIR="/data/biosboot/pubchain"
GENESIS_NUM=101
HOSTNAME=$(hostname)
num=${HOSTNAME#node}
echo $num

if [ "$num" == "$GENESIS_NUM" ]
then
	echo "genesis start."
    ./importKey.sh

    GENESIS_ACCOUNT_PROVIDER="TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM=KEY:5JLrjLzKiWvecrUkBBPEBm4Wt8F7ECygLNnLhhLW64fCGP5RUvH"
    HTTP_LISTEN_PORT=8888
    P2P_LISTEN_PORT=9010
    DATADIR=${BASE_DIR}"/genesis"
    PROVIDER=$GENESIS_ACCOUNT_PROVIDER
    NAME="T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T"

    mkdir -p "$DATADIR"

    setCommand    
    echo $CMD
    eval $CMD

    sleep 1
    ./setConfigNormal.sh $CONTRACT_PATH
    #./setConfigVote140.sh
    #./test_command.sh
	echo "genesis start end."
else
    echo "full node start."
    keyNum=`expr ${num} - ${GENESIS_NUM} - 1`
    if [ "$keyNum" -ge "0" ] && [ "$keyNum" -lt "${#public_keys[@]}" ];
    then
        currentKey=${public_keys[$keyNum]}
        echo "currentKey "$currentKey
        cureentAddress=$(./getAddressTool $currentKey | grep address | awk '{print $3}')
    else
        echo "keyNum is not rightfull: " $keyNum
        exit 0
    fi
    FULLNODE_ACCOUNT=$cureentAddress
    FULLNODE_ACCOUNT_PROVIDER="TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX=KEY:5HxK6mfoNr1pbnbYs1AmsKjavJQaoxiNVUdeJD6ZPFZkQvGcZVM"
    HTTP_LISTEN_PORT=8888
    P2P_LISTEN_PORT=9010
    DATADIR=${BASE_DIR}"/$num"
    PROVIDER=$FULLNODE_ACCOUNT_PROVIDER
    NAME=$FULLNODE_ACCOUNT

    mkdir -p "$DATADIR"
    echo "cureentAddress is: $cureentAddress" >> $DATADIR"/info.txt"
    echo "keyNum is ${keyNum} " >> $DATADIR"/info.txt"
    echo "currentKey is ${currentKey} " >> $DATADIR"/info.txt"

    setCommand
    echo $CMD
    eval $CMD

    echo "full node start end."
fi
