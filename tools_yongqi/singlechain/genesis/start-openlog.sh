#!/bin/bash
DATADIR="./blockchain"
CURDIRNAME=${PWD##*/}

if [ ! -d $DATADIR ]; then
  mkdir -p $DATADIR;
fi

#注意：以下参数做为标记配置参数使用，方便统一修改配置
config_general="--p2p-peer-address 1.1.1.1:9001"
config_genesis_start="--p2p-peer-address 1.1.1.1:9002"
config_personality="--p2p-peer-address 1.1.1.1:9003"
config_genesis_node="--p2p-peer-address 1.1.1.1:9004"
config_not_genesis_node="--p2p-peer-address 1.1.1.1:9005"
config_other="--p2p-peer-address 1.1.1.1:9006"
config_hard_replay="--p2p-peer-address 1.1.1.1:9007"

tafcored \
${config_general} \
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
${config_personality} \
--plugin tafsys::maker_plugin \
--plugin tafsys::maker_api_plugin \
--plugin tafsys::chain_plugin \
--plugin tafsys::chain_api_plugin \
--plugin tafsys::http_plugin \
--plugin tafsys::history_api_plugin \
--plugin tafsys::history_plugin \
--filter-on="*" \
--chain-state-db-size-mb=10240 \
--data-dir $DATADIR"/data" \
--blocks-dir $DATADIR"/blocks" \
--config-dir $DATADIR"/config" \
${config_not_genesis_node} \
--maker-name $CURDIRNAME \
--signature-provider TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX=KEY:5HxK6mfoNr1pbnbYs1AmsKjavJQaoxiNVUdeJD6ZPFZkQvGcZVM \
--http-server-address 127.0.0.1:8888 \
--p2p-listen-endpoint 0.0.0.0:9010 \
--access-control-allow-origin=* \
--contracts-console \
--http-validate-host=false \
--verbose-http-errors \
--enable-stale-production \
--logconf /home/yanfa-1/tafsys/taf/programs/tafcored/logging.json \
--p2p-peer-address localhost:9011 \
--p2p-peer-address localhost:9012 \
--p2p-peer-address localhost:9013 \
${config_other} \
>> $DATADIR"/tafcored.log" 2>&1 & \
echo $! > $DATADIR"/tafd.pid"
