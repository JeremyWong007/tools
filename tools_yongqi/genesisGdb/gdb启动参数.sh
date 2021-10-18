#!/bin/bash

tafcored \
--plugin tafsys::maker_plugin \
--plugin tafsys::maker_api_plugin \
--plugin tafsys::chain_plugin \
--plugin tafsys::chain_api_plugin \
--plugin tafsys::http_plugin \
--plugin tafsys::history_api_plugin \
--plugin tafsys::history_plugin \
--data-dir "/data/info/git/biosboot/genesis_gdb/blockchain/data" \
--blocks-dir "/data/info/git/biosboot/genesis_gdb/blockchain/blocks" \
--config-dir "/data/info/git/biosboot/genesis_gdb/blockchain/config" \
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
--genesis-json "/data/info/git/biosboot/genesis.json" \
--http-server-address 0.0.0.0:8888 \
--p2p-listen-endpoint 0.0.0.0:9010 \
--p2p-peer-address localhost:9010 \
--p2p-peer-address localhost:9011 \
--p2p-peer-address localhost:9012 \
--p2p-peer-address localhost:9013 \
--maker-name tsystem \
--signature-provider TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM=KEY:5JLrjLzKiWvecrUkBBPEBm4Wt8F7ECygLNnLhhLW64fCGP5RUvH \
>> "/data/info/git/biosboot/genesis_gdb/tafcored.log" 2>&1 & \
echo $! > "/data/info/git/biosboot/genesis_gdb/tafd.pid"
