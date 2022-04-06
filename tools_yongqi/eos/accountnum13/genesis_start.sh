#!/bin/bash
DATADIR="./blockchain"
CURDIRNAME=${PWD##*/}

if [ ! -d $DATADIR ]; then
  mkdir -p $DATADIR;
fi

#注意：以下参数做为标记配置参数使用，方便统一修改配置
config_general="--p2p-peer-address 1.1.1.1:7001"
config_genesis_start="--p2p-peer-address 1.1.1.1:7002"
config_personality="--p2p-peer-address 1.1.1.1:7003"
config_genesis_node="--p2p-peer-address 1.1.1.1:7004"
config_not_genesis_node="--p2p-peer-address 1.1.1.1:7005"
config_other="--p2p-peer-address 1.1.1.1:7006"
config_hard_replay="--p2p-peer-address 1.1.1.1:7007"

nodeos \
${config_general} \
--plugin eosio::producer_plugin \
--plugin eosio::producer_api_plugin \
--plugin eosio::chain_plugin \
--plugin eosio::chain_api_plugin \
--plugin eosio::http_plugin \
--plugin eosio::history_api_plugin \
--plugin eosio::history_plugin \
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
--keosd-provider-timeout 5000 \
--p2p-max-nodes-per-host 100 \
--chain-state-db-size-mb=102400 \
${config_genesis_start} \
--genesis-json $DATADIR"/../../genesis.json" \
${config_personality} \
--http-server-address 127.0.0.1:5013 \
--p2p-listen-endpoint 127.0.0.1:7013 \
--p2p-peer-address localhost:7010 \
--p2p-peer-address localhost:7011 \
--p2p-peer-address localhost:7012 \
--p2p-peer-address localhost:7013 \
${config_not_genesis_node} \
--producer-name $CURDIRNAME \
--signature-provider EOS5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX=KEY:5HxK6mfoNr1pbnbYs1AmsKjavJQaoxiNVUdeJD6ZPFZkQvGcZVM \
${config_other} \
>> $DATADIR"/nodeos.log" 2>&1 & \
echo $! > $DATADIR"/eosd.pid"
