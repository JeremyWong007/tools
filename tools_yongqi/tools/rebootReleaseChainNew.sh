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

function correctNum(){
    if [ $NUM_TMP -lt 101 ]; then
        NUM_TMP=`expr 240 - 100 + $NUM_TMP`
    elif [ $NUM_TMP -gt 240 ]; then
        NUM_TMP=`expr $NUM_TMP - 240 + 100`
    fi
}

function setP2pAddrLocal2Local(){
    NUM_TMP=`expr $num + 101  - 1`
    correctNum
    numb1=$NUM_TMP
    NUM_TMP=`expr $num + 101 - 2`
    correctNum
    numb2=$NUM_TMP
    NUM_TMP=`expr $num + 101 - 3`
    correctNum
    numb3=$NUM_TMP
    NUM_TMP=`expr $num + 101 - 4`
    correctNum
    numb4=$NUM_TMP
    NUM_TMP=`expr $num + 101 - 5`
    correctNum
    numb5=$NUM_TMP
    NUM_TMP=`expr $num + 101 + 1`
    correctNum
    num1=$NUM_TMP
    NUM_TMP=`expr $num + 101 + 2`
    correctNum
    num2=$NUM_TMP
    NUM_TMP=`expr $num + 101 + 3`
    correctNum
    num3=$NUM_TMP
    NUM_TMP=`expr $num + 101 + 4`
    correctNum
    num4=$NUM_TMP
    NUM_TMP=`expr $num + 101 + 5`
    correctNum
    num5=$NUM_TMP
    NUM_TMP=`expr $num + 101 + 32`
    correctNum
    numj1=$NUM_TMP
    NUM_TMP=`expr $num + 101 + 48`
    correctNum
    numj2=$NUM_TMP
    NUM_TMP=`expr $num + 101 + 64`
    correctNum
    numj3=$NUM_TMP
    NUM_TMP=`expr $num + 101 + 80`
    correctNum
    numj4=$NUM_TMP
    NUM_TMP=`expr $num + 101 + 96`
    correctNum
    numj5=$NUM_TMP
    echo "show p2p num: $numb5 $numb4 $numb3 $numb2 $numb1 $num1 $num2 $num3 $num4 $num5 $numj1 $numj2 $numj3 $numj4 $numj5"
    SETTING_P2P_ADDRESS_LOCAL2LOCAL="--p2p-peer-address 192.168.101.$num1:9010 \
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
    --p2p-peer-address 192.168.101.$numj5:9010"
}

function setP2pAddrPubAli(){
    SETTING_P2P_ADDRESS="--p2p-peer-address 121.41.199.39:9010 \
    --p2p-peer-address 121.41.200.60:9010 \
    --p2p-peer-address 13.230.34.236:9010 \
    --p2p-peer-address 18.176.224.246:9010 \
    --p2p-peer-address 18.180.156.94:9010 \
    --p2p-peer-address 35.77.32.87:9010 \
    --p2p-peer-address 35.75.22.237:9010 \
    --p2p-peer-address 18.183.203.208:9010 \
    --p2p-peer-address 3.112.63.128:9010 \
    --p2p-peer-address 3.115.1.53:9010 \
    --p2p-peer-address 35.72.35.95:9010 \
    --p2p-peer-address 35.74.253.51:9010 \
    --p2p-peer-address 35.74.78.197:9010 \
    --p2p-peer-address 35.76.107.8:9010 \
    --p2p-peer-address 220.189.210.50:9221 \
    --p2p-peer-address 220.189.210.50:9213 \
    --p2p-peer-address 220.189.210.50:9205 \
    --p2p-peer-address 220.189.210.50:9197 \
    --p2p-peer-address 220.189.210.50:9189 \
    --p2p-peer-address 220.189.210.50:9181 \
    --p2p-peer-address 220.189.210.50:9173 \
    --p2p-peer-address 220.189.210.50:9165 \
    --p2p-peer-address 220.189.210.50:9157 \
    --p2p-peer-address 220.189.210.50:9149 \
    --p2p-peer-address 220.189.210.50:9141 \
    --p2p-peer-address 220.189.210.50:9133 \
    --p2p-peer-address 220.189.210.50:9125 \
    --p2p-peer-address 220.189.210.50:9117 \
    --p2p-peer-address 220.189.210.50:9229 \
    --p2p-peer-address 220.189.210.50:9109"
}

function setP2pAddrPubYMX(){
    SETTING_P2P_ADDRESS="--p2p-peer-address 121.41.199.39:9010 \
    --p2p-peer-address 121.41.200.60:9010 \
    --p2p-peer-address 13.230.34.236:9010 \
    --p2p-peer-address 18.176.224.246:9010 \
    --p2p-peer-address 18.180.156.94:9010 \
    --p2p-peer-address 35.77.32.87:9010 \
    --p2p-peer-address 35.75.22.237:9010 \
    --p2p-peer-address 18.183.203.208:9010 \
    --p2p-peer-address 3.112.63.128:9010 \
    --p2p-peer-address 3.115.1.53:9010 \
    --p2p-peer-address 35.72.35.95:9010 \
    --p2p-peer-address 35.74.253.51:9010 \
    --p2p-peer-address 35.74.78.197:9010 \
    --p2p-peer-address 35.76.107.8:9010"
}

#220.189.210.50为140服务器对应外网IP
function setP2pAddrLocalV2(){
    SETTING_P2P_ADDRESS="--p2p-peer-address 192.168.101.101:9010 \
    --p2p-peer-address 192.168.101.102:9010 \
    --p2p-peer-address 192.168.101.103:9010 \
    --p2p-peer-address 192.168.101.104:9010 \
    --p2p-peer-address 192.168.101.105:9010 \
    --p2p-peer-address 192.168.101.106:9010 \
    --p2p-peer-address 192.168.101.107:9010 \
    --p2p-peer-address 192.168.101.108:9010 \
    --p2p-peer-address 192.168.101.109:9010 \
    --p2p-peer-address 192.168.101.110:9010 \
    --p2p-peer-address 192.168.101.111:9010 \
    --p2p-peer-address 192.168.101.112:9010 \
    --p2p-peer-address 192.168.101.113:9010 \
    --p2p-peer-address 192.168.101.114:9010 \
    --p2p-peer-address 192.168.101.115:9010 \
    --p2p-peer-address 192.168.101.116:9010 \
    --p2p-peer-address 121.41.193.65:9010 \
    --p2p-peer-address 121.41.197.161:9010 \
    --p2p-peer-address 121.41.197.238:9010 \
    --p2p-peer-address 121.41.197.97:9010 \
    --p2p-peer-address 121.41.199.181:9010 \
    --p2p-peer-address 3.115.1.53:9010"
}

function setP2pAddrPubV2(){
    SETTING_P2P_ADDRESS="--p2p-peer-address 121.41.193.65:9010 \
    --p2p-peer-address 121.41.197.161:9010 \
    --p2p-peer-address 121.41.197.238:9010 \
    --p2p-peer-address 121.41.197.97:9010 \
    --p2p-peer-address 121.41.199.181:9010 \
    --p2p-peer-address 3.115.1.53:9010 \
    --p2p-peer-address 220.189.210.50:9010 \
    --p2p-peer-address 220.189.210.50:9102 \
    --p2p-peer-address 220.189.210.50:9103 \
    --p2p-peer-address 220.189.210.50:9104 \
    --p2p-peer-address 220.189.210.50:9105 \
    --p2p-peer-address 220.189.210.50:9109"
}

function setP2pAddrV3(){
    SETTING_P2P_ADDRESS="--p2p-peer-address 121.41.199.36:9010 \
    --p2p-peer-address 121.41.199.39:9010 \
    --p2p-peer-address 121.41.193.65:9010 \
    --p2p-peer-address 121.41.197.161:9010 \
    --p2p-peer-address 121.41.197.238:9010 \
    --p2p-peer-address 121.41.197.97:9010 \
    \
    --p2p-peer-address 35.72.35.95:9010 \
    --p2p-peer-address 35.74.78.197:9010 \
    --p2p-peer-address 13.230.34.236:9010 \
    --p2p-peer-address 18.176.224.246:9010 \
    --p2p-peer-address 18.180.156.94:9010 \
    --p2p-peer-address 35.77.32.87:9010 \
    --p2p-peer-address 35.75.22.237:9010 \
    --p2p-peer-address 18.183.203.208:9010 \
    --p2p-peer-address 3.112.63.128:9010 \
    --p2p-peer-address 3.115.1.53:9010 \
    --p2p-peer-address 35.74.253.51:9010 \
    --p2p-peer-address 35.76.107.8:9010 "
    
    SETTING_P2P_ADDRESS_LOCAL2PUB="--p2p-peer-address 220.189.210.50:9221 \
    --p2p-peer-address 220.189.210.50:9213 \
    --p2p-peer-address 220.189.210.50:9205 \
    --p2p-peer-address 220.189.210.50:9197 \
    --p2p-peer-address 220.189.210.50:9189 \
    --p2p-peer-address 220.189.210.50:9181 \
    --p2p-peer-address 220.189.210.50:9173 \
    --p2p-peer-address 220.189.210.50:9165 \
    --p2p-peer-address 220.189.210.50:9157 \
    --p2p-peer-address 220.189.210.50:9149 \
    --p2p-peer-address 220.189.210.50:9141 \
    --p2p-peer-address 220.189.210.50:9133 \
    --p2p-peer-address 220.189.210.50:9125 \
    --p2p-peer-address 220.189.210.50:9117 \
    --p2p-peer-address 220.189.210.50:9229 \
    --p2p-peer-address 220.189.210.50:9109 \
    \
    --p2p-peer-address 220.189.210.50:9010 \
    --p2p-peer-address 220.189.210.50:9102 \
    --p2p-peer-address 220.189.210.50:9103 \
    --p2p-peer-address 220.189.210.50:9104 \
    --p2p-peer-address 220.189.210.50:9105 \
    --p2p-peer-address 220.189.210.50:9109 "
    echo "num is $num"
    if [ ${num} -lt 140 ]; then
        setP2pAddrLocal2Local
        SETTING_P2P_ADDRESS=${SETTING_P2P_ADDRESS}${SETTING_P2P_ADDRESS_LOCAL2LOCAL}
        echo $SETTING_P2P_ADDRESS
    else
        SETTING_P2P_ADDRESS=${SETTING_P2P_ADDRESS}${SETTING_P2P_ADDRESS_LOCAL2PUB}
        echo $SETTING_P2P_ADDRESS
    fi
}

function setP2pAddrV4(){
    SETTING_P2P_ADDRESS_PUB="--p2p-peer-address 121.41.199.36:9010 \
    --p2p-peer-address 121.41.199.39:9010 \
    --p2p-peer-address 121.41.193.65:9010 \
    --p2p-peer-address 121.41.197.161:9010 \
    --p2p-peer-address 121.41.197.238:9010 \
    --p2p-peer-address 121.41.197.97:9010 \
    \
    --p2p-peer-address 35.72.35.95:9010 \
    --p2p-peer-address 35.74.78.197:9010 \
    --p2p-peer-address 13.230.34.236:9010 \
    --p2p-peer-address 18.176.224.246:9010 \
    --p2p-peer-address 18.180.156.94:9010 \
    --p2p-peer-address 35.77.32.87:9010 \
    --p2p-peer-address 35.75.22.237:9010 \
    --p2p-peer-address 18.183.203.208:9010 \
    --p2p-peer-address 3.112.63.128:9010 \
    --p2p-peer-address 3.115.1.53:9010 \
    --p2p-peer-address 35.74.253.51:9010 \
    --p2p-peer-address 35.76.107.8:9010 "
    
    SETTING_P2P_ADDRESS_PUB2LOCAL="--p2p-peer-address 220.189.210.50:9221 \
    --p2p-peer-address 220.189.210.50:9213 "
    echo "num is $num"
    if [ ${num} -lt 140 ]; then
        setP2pAddrLocal2Local
        if [ ${num} -ge 138 ]; then
            SETTING_P2P_ADDRESS=${SETTING_P2P_ADDRESS_PUB}${SETTING_P2P_ADDRESS_LOCAL2LOCAL}
        else
            SETTING_P2P_ADDRESS=${SETTING_P2P_ADDRESS_LOCAL2LOCAL}
        fi
    else
        if [[ ${num} == ${AliHostNum["121.41.193.65"]} || ${num} == ${YamaxunHostNum["13.230.34.236"]} ]]; then
            SETTING_P2P_ADDRESS=${SETTING_P2P_ADDRESS_PUB}${SETTING_P2P_ADDRESS_PUB2LOCAL}
        else
            SETTING_P2P_ADDRESS=${SETTING_P2P_ADDRESS_PUB}
        fi
    fi
    echo $SETTING_P2P_ADDRESS
}

function setP2pAddrV5(){
    SETTING_P2P_ADDRESS_PUB="--p2p-peer-address 121.41.199.36:9010 \
    --p2p-peer-address 121.41.199.39:9010 \
    --p2p-peer-address 121.41.193.65:9010 \
    --p2p-peer-address 121.41.197.161:9010 \
    --p2p-peer-address 121.41.197.238:9010 \
    --p2p-peer-address 121.41.197.97:9010 \
    \
    --p2p-peer-address 35.72.35.95:9010 \
    --p2p-peer-address 35.74.78.197:9010 \
    --p2p-peer-address 13.230.34.236:9010 \
    --p2p-peer-address 18.176.224.246:9010 \
    --p2p-peer-address 18.180.156.94:9010 \
    --p2p-peer-address 35.77.32.87:9010 \
    --p2p-peer-address 35.75.22.237:9010 \
    --p2p-peer-address 18.183.203.208:9010 \
    --p2p-peer-address 3.112.63.128:9010 \
    --p2p-peer-address 3.115.1.53:9010 \
    --p2p-peer-address 35.74.253.51:9010 \
    --p2p-peer-address 35.76.107.8:9010 "

    SETTING_P2P_ADDRESS_LOCAL2LOCAL="--p2p-peer-address 192.168.101.101:9010 \
    --p2p-peer-address 192.168.101.102:9010 \
    --p2p-peer-address 192.168.101.103:9010 \
    --p2p-peer-address 192.168.101.109:9010 \
    --p2p-peer-address 192.168.101.110:9010 \
    --p2p-peer-address 192.168.101.111:9010 \
    --p2p-peer-address 192.168.101.117:9010 \
    --p2p-peer-address 192.168.101.118:9010 \
    --p2p-peer-address 192.168.101.119:9010 \
    --p2p-peer-address 192.168.101.125:9010 \
    --p2p-peer-address 192.168.101.126:9010 \
    --p2p-peer-address 192.168.101.127:9010 \
    --p2p-peer-address 192.168.101.141:9010"
    
    SETTING_P2P_ADDRESS_PUB2LOCAL="--p2p-peer-address 220.189.210.50:9012 \
    --p2p-peer-address 220.189.210.50:9013 "
    echo "num is $num"
    if [ ${num} -lt 140 ]; then
        if [ ${num} -ge 138 ]; then
            SETTING_P2P_ADDRESS=${SETTING_P2P_ADDRESS_PUB}${SETTING_P2P_ADDRESS_LOCAL2LOCAL}
        else
            SETTING_P2P_ADDRESS=${SETTING_P2P_ADDRESS_LOCAL2LOCAL}
        fi
    else
        if [[ ${num} == ${AliHostNum["121.41.193.65"]} || ${num} == ${YamaxunHostNum["13.230.34.236"]} ]]; then
            SETTING_P2P_ADDRESS=${SETTING_P2P_ADDRESS_PUB}${SETTING_P2P_ADDRESS_PUB2LOCAL}
        else
            SETTING_P2P_ADDRESS=${SETTING_P2P_ADDRESS_PUB}
        fi
    fi
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
    --genesis-json "../genesis2.json" \
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
    echo " ./rebootReleaseChainNew.sh --p2pAddr local140"
    echo " ./rebootReleaseChainNew.sh --p2pAddr pubAli"
    echo " ./rebootReleaseChainNew.sh --p2pAddr pubYmx"
    echo " ./rebootReleaseChainNew.sh --p2pAddr pubAli --clean"
    echo " ./rebootReleaseChainNew.sh --p2pAddr pubAli --hardReplay"
    echo " ./rebootReleaseChainNew.sh --p2pAddr localv2 --clean"
    echo " ./rebootReleaseChainNew.sh --p2pAddr pubv2 --clean"
    echo " ./rebootReleaseChainNew.sh --p2pAddr v3"
    echo " ./rebootReleaseChainNew.sh --p2pAddr v4 #对应157节点的大网络"
    echo " ./rebootReleaseChainNew.sh --p2pAddr v5 #对应缩小后的小网络，内部测试网"
    exit 1
}

ARGS=`getopt -o h --long clean,hardReplay,p2pAddr: -n 'rebootReleaseChainNew.sh' -- "$@"`
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
                local140)
                    echo "p2pAddr is local140"
                    setP2pAddrLocal140
                    shift 2
                    ;;
                pubAli)
                    echo "p2pAddr is pubAli"
                    setP2pAddrPubAli
                    shift 2
                    ;;
                pubYmx)
                    echo "p2pAddr is pubYmx"
                    setP2pAddrPubYMX
                    shift 2
                    ;;
                localv2)
                    echo "p2pAddr is localv2"
                    setP2pAddrLocalV2
                    shift 2
                    ;;
                pubv2)
                    echo "p2pAddr is pubv2"
                    setP2pAddrPubV2
                    shift 2
                    ;;
                v3)
                    echo "p2pAddr is v3"
                    setP2pAddrV3
                    shift 2
                    ;;
                v4)
                    echo "p2pAddr is v4"
                    setP2pAddrV4
                    shift 2
                    ;;
                v5)
                    echo "p2pAddr is v5"
                    setP2pAddrV5
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
