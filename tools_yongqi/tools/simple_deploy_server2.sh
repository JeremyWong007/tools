#!/bin/bash

#set -x

if [ $1 != "first" ]; then
    if [ $# != 2 ]; then
        exit -1
    fi
    WORK_NODES_START=$1 #节点起始编号
    WORK_NODES_END=$2 #节点结束编号
    MAKER_NUM_START=$1 #生产者起始编号
    MAKER_NUM_END=$2 #生产者结束编号
else
    WORK_NODES_START=0
    WORK_NODES_END=0
    MAKER_NUM_START=0
    MAKER_NUM_END=0
fi

GENESIS_SERVER_IP_PORT="192.168.0.230:9510"
#GENESIS_SERVER_IP_PORT="35.76.107.8:9510"

#公钥 TAF8mUftJXepGzdQ2TaCduNuSPAfXJHf22uex4u41ab1EVv9EAhWt
#私钥 5K7EYY3j1YY14TSFVfqgtbWbrw3FA8BUUnSyFGgwHi8Uy61wU1o
FIRST_ACCOUNT="T12BSJuiScm4BkzJhafXPek6Uy2kxmkPm" #无需创建

source globalInfo.sh
./importKey.sh


if [ "${#private_keys2[@]}" -ne "${#public_keys2[@]}" ]; then
    echo "public key and private key count not equal"
    exit 0
fi

if [ "$WORK_NODES_END" -gt "${#private_keys2[@]}" ]; then
    echo "work node is too big"
    exit 0
fi

maker_name_array=()

# unlock wallet
#tafclient wallet unlock --password $WALLET_PWD
./unlock.sh

# import private keys
for((i=$WORK_NODES_START;i<$WORK_NODES_END;i++));
do
    PRIV_KEY=${private_keys2[i]}
    tafclient wallet importkey --private-key $PRIV_KEY
done

# start first node
HTTP_LISTEN_PORT=8888
P2P_LISTEN_PORT=9510
P2P_LISTEN_PORT_TO=`expr 9510 + 1`
DATADIR="/tmp/taftest/first"
PROVIDER="TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX=KEY:5HxK6mfoNr1pbnbYs1AmsKjavJQaoxiNVUdeJD6ZPFZkQvGcZVM"
NAME=$FIRST_ACCOUNT

if [ $1 == "first" ];
then
    killall tafcored
    rm -rf /tmp/taftest/*
    mkdir -p "$DATADIR"

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
    --p2p-max-nodes-per-host 200 \
    --chain-state-db-size-mb=102400 \
    --genesis-json "../genesis.json" \
    --logconf=../logging.json \
    --http-server-address 0.0.0.0:$HTTP_LISTEN_PORT \
    --p2p-listen-endpoint 0.0.0.0:$P2P_LISTEN_PORT \
    --p2p-peer-address localhost:$P2P_LISTEN_PORT_TO \
    --p2p-peer-address $GENESIS_SERVER_IP_PORT \
    --maker-name $NAME \
    --signature-provider $PROVIDER \
    >> $DATADIR"/tafcored.log" 2>&1 & \
    echo $! > $DATADIR"/tafd.pid" "

    echo $CMD
    eval $CMD
    exit 0
fi
sleep 1

# create all account and get name
echo "create all account and get name:"
for((i=$WORK_NODES_START;i<$WORK_NODES_END;i++));
do
    PUB_KEY=${public_keys2[i]}
    RSP=`tafclient new account $PUB_KEY`
    RESULT=`echo $RSP | awk -F 'account address: ' '{print $2}' `
    # if is empty, exit
    maker_name_array[i]=$RESULT
    echo $i $RESULT
done

# start work nodes
for((i=$WORK_NODES_START;i<$WORK_NODES_END;i++));
do
    HTTP_LISTEN_PORT=`expr 8888 + $i + 1`
    P2P_LISTEN_PORT=`expr 9510 + $i + 1`
    if [ $i == $WORK_NODES_START ];
    then
        P2P_LISTEN_PORT_TO=9510
    else
        P2P_LISTEN_PORT_TO=`expr $P2P_LISTEN_PORT - 1`
    fi
    DATADIR="/tmp/taftest/$i"
    PROVIDER="TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX=KEY:5HxK6mfoNr1pbnbYs1AmsKjavJQaoxiNVUdeJD6ZPFZkQvGcZVM"
    NAME=${maker_name_array[i]}

    mkdir -p "$DATADIR"

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
    --p2p-max-nodes-per-host 200 \
    --chain-state-db-size-mb=102400 \
    --genesis-json "../genesis.json" \
    --logconf=../logging.json \
    --http-server-address 0.0.0.0:$HTTP_LISTEN_PORT \
    --p2p-listen-endpoint 0.0.0.0:$P2P_LISTEN_PORT \
    --p2p-peer-address localhost:$P2P_LISTEN_PORT_TO \
    --maker-name $NAME \
    --signature-provider $PROVIDER \
    >> $DATADIR"/tafcored.log" 2>&1 & \
    echo $! > $DATADIR"/tafd.pid" "

    echo $CMD
    eval $CMD
done

sleep 1

ICO_ACCOUNT="T18otnQRXsMjdrMgLWp7XdbXKL8jgJvB3uQ"

# transfer to work node
for((i=$WORK_NODES_START;i<$WORK_NODES_END;i++));
do
    NAME=${maker_name_array[i]}
    CMD="tafclient transfer $ICO_ACCOUNT $NAME \"20000.0000 TAFT\""
    echo $CMD
    eval $CMD 
done

sleep 1

# stake
for((i=$WORK_NODES_START;i<$WORK_NODES_END;i++));
do
    NAME=${maker_name_array[i]}
    tafclient maker delegatesource $NAME $NAME "10000.0000 TAFT" "10000.0000 TAFT"
done

sleep 1

# register as maker
for((i=$MAKER_NUM_START;i<$MAKER_NUM_END;i++));
do
    NAME=${maker_name_array[i]}
    tafclient maker regmaker $NAME TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://$NAME.com
done

sleep 1

tafclient maker listmakers

# vote
votelist=""

for((i=$MAKER_NUM_START;i<$MAKER_NUM_END;i++));
do
    NAME=${maker_name_array[i]}
    CMD="tafclient maker votemakers prods $NAME $NAME"
    echo $CMD
    eval $CMD
done

tafclient maker listmakers
