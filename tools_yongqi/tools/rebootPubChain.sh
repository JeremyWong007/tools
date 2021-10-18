#!/bin/bash
set -u
set -x

CURRENT_DIR="$(cd "$(dirname "$0")"; pwd)"
cd $CURRENT_DIR

version=$1
pkill tafcored
sleep 0.1
rm -rf ${TAF_PUB_SHELL_PATH}
sleep 0.1

#打开钱包
./unlock.sh

tafclient wallet importkey --private-key 5JaEDAYW5pwy35YVHieUHqaFNbTg4wVM8JuCiA4fbMygcV1L5qU
tafclient wallet importkey --private-key 5K9WNyqGvzqdHK7nVwxy1dwXGy2Aw2ry24NiXeNZXuHNM42sy6F
tafclient wallet importkey --private-key 5KX6m3DxC6uD7cz2j44ShYrTeGigFcDgVxTZqWR12nriBvqjwfH
tafclient wallet importkey --private-key 5KBEDKJoxJ18JHuSfNDisMQrCq4toQADZ4VTvEnG4Jw9E17phLb
tafclient wallet importkey --private-key 5JM5ex4NyJmHw1A5rCfCaPSAFvNdhHmPm2MnT9Tcw4oLNUMo4gQ
tafclient wallet importkey --private-key 5KTyvSt85D1bNR2dp9vrCX3gbmSxx4YPaBvrhnovbg1i3ArCL96
tafclient wallet importkey --private-key 5K4mHZAgduJo9BXKj9mmgMUwEXU6rbfCt49Jd3XnxhfmA1WEsA4
tafclient wallet importkey --private-key 5KAGCzqdNbfSdjBTGQ985jER49ffCfgvAX8ryGuQq1JK8RtRkRM
tafclient wallet importkey --private-key 5JXCwmLEHR2DPae1CSCzCcvaUP4YFQVcbqBCSYysSkat6RfVaDj
tafclient wallet importkey --private-key 5KTVSrVVt3JP1VFMbY5zBENfg6b5eMDdGeRwjX2wy9trfiB1fCX

function setCommand(){
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
    --genesis-json "../genesis.json" \
    --logconf=../logging.json \
    --http-server-address 0.0.0.0:$HTTP_LISTEN_PORT \
    --p2p-listen-endpoint 0.0.0.0:$P2P_LISTEN_PORT \
    --p2p-peer-address 121.41.193.65:9010 \
    --p2p-peer-address 121.41.197.161:9010 \
    --p2p-peer-address 121.41.197.238:9010 \
    --p2p-peer-address 121.41.197.97:9010 \
    --p2p-peer-address 121.41.199.181:9010 \
    --p2p-peer-address 121.41.199.188:9010 \
    --p2p-peer-address 121.41.199.36:9010 \
    --p2p-peer-address 121.41.199.39:9010 \
    --p2p-peer-address 121.41.200.49:9010 \
    --p2p-peer-address 121.41.200.60:9010 \
    --maker-name $NAME \
    --signature-provider $PROVIDER \
    >> $DATADIR"/tafcored.log" 2>&1 & "
    #echo $! > $DATADIR"/tafd.pid" "
}

if [ "${TAF_PUB_SHELL_PATH##*/}" == "genesis" ]
then
	echo "genesis start."
    GENESIS_ACCOUNT="T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T"
    GENESIS_ACCOUNT_PROVIDER="TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM=KEY:5JLrjLzKiWvecrUkBBPEBm4Wt8F7ECygLNnLhhLW64fCGP5RUvH"
    HTTP_LISTEN_PORT=8888
    P2P_LISTEN_PORT=9010
    DATADIR=${TAF_PUB_SHELL_PATH}
    PROVIDER=$GENESIS_ACCOUNT_PROVIDER
    NAME=$GENESIS_ACCOUNT

    mkdir -p "$DATADIR"

    setCommand    
    echo $CMD
    eval $CMD

    sleep 1
    ./setConfigNormal.sh /data/info/file/release_${version}/contracts
    ./setConfigVote7.sh
    #./test_command.sh
	echo "genesis start end."
else
    echo "full node start."
    FULLNODE_ACCOUNT=${TAF_PUB_SHELL_PATH##*/}
    FULLNODE_ACCOUNT_PROVIDER="TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX=KEY:5HxK6mfoNr1pbnbYs1AmsKjavJQaoxiNVUdeJD6ZPFZkQvGcZVM"
    HTTP_LISTEN_PORT=8888
    P2P_LISTEN_PORT=9010
    DATADIR=${TAF_PUB_SHELL_PATH}
    PROVIDER=$FULLNODE_ACCOUNT_PROVIDER
    NAME=$FULLNODE_ACCOUNT

    mkdir -p "$DATADIR"

    setCommand
    echo $CMD
    eval $CMD

    echo "full node start end."
fi
