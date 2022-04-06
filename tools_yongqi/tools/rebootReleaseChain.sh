#!/bin/bash
#set -e #当脚本中任何以一个命令执行返回的状态码不为0时就退出整个脚本
#set -u #当脚本在执行过程中尝试使用未定义过的变量时，报错并退出运行整个脚本
#set -x #设置-x选项后，之后执行的每一条命令，都会显示的打印出来

CURRENT_DIR="$(cd "$(dirname "$0")"; pwd)"
cd $CURRENT_DIR

source globalInfo.sh
source /data/info/env.taf

BASE_DIR="/data/biosboot/pubchain"
num=$TAF_NODE_NUM
echo $num

function setP2pAddrV1(){
    SETTING_P2P_ADDRESS="--p2p-peer-address 192.168.0.230:9010 \
    --p2p-peer-address 192.168.0.232:9010 \
    --p2p-peer-address 192.168.0.233:9010 "
    echo $SETTING_P2P_ADDRESS
}

function setCommand(){    
    CMD="tafcored \
    --plugin tafsys::maker_plugin \
    --plugin tafsys::maker_api_plugin \
    --plugin tafsys::chain_plugin \
    --plugin tafsys::chain_api_plugin \
    --plugin tafsys::http_plugin \
    --plugin tafsys::history_api_plugin \
    --plugin tafsys::history_plugin \
    --plugin tafsys::net_plugin \
    --plugin tafsys::txn_test_gen_plugin \
    --txn-test-gen-threads 6 \
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
    --max-clients 300 \
    --genesis-json "../genesis3.json" \
    --logconf=../logging.json \
    --http-server-address 0.0.0.0:$HTTP_LISTEN_PORT \
    --p2p-listen-endpoint 0.0.0.0:$P2P_LISTEN_PORT \
    $SETTING_P2P_ADDRESS \
    $HARD_REPLAY_CONFIG \
    --maker-name $NAME \
    --signature-provider $PROVIDER \
    >> $DATADIR"/tafcored.log" 2>&1 & "
    #echo $! > $DATADIR"/tafd.pid" "
}

function cleanRoom(){
    rm -rf "/data/biosboot/pubchain"
    sleep 0.1
}

function usage() {
    echo "Usage:"
    echo " getopt <optstring> <parameters>"
    echo ""
    echo "Exapmple:"
    echo " ./rebootReleaseChain.sh --p2pAddr v1"
    exit 1
}

ARGS=`getopt -o h --long clean,hardReplay,p2pAddr: -n 'rebootReleaseChain.sh' -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

#将规范化后的命令行参数分配至位置参数（$1,$2,...)
eval set -- "${ARGS}"
while true
do
    case "$1" in
        --clean)
            CLEAN_OLD_BLOCK="true"
            shift
            ;;
        --hardReplay)
            echo "set --hard-replay-blockchain"
            HARD_REPLAY_CONFIG="--hard-replay-blockchain"
            shift
            ;;
        --p2pAddr)
            case "$2" in
                v1)
                    echo "p2pAddr is v1"
                    setP2pAddrV1
                    shift 2
                    ;;
            esac
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

pkillAndWait tafcored
if [ "$CLEAN_OLD_BLOCK" == "true" ]; then
    echo "cleanRoom in"
    cleanRoom
fi
getContractPath $@

if [ "$num" == "0" ]
then
	echo "genesis start."
    #打开钱包
    ./unlock.sh
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
    
    if [ "$CLEAN_OLD_BLOCK" == "true" ]; then
        sleep 1
        #./setConfigNormal.sh $CONTRACT_PATH
        #./setConfigVote140.sh 21
        #./test_command.sh
    fi
	echo "genesis start end."
else
    echo "full node start."
    keyNum=${num}
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
