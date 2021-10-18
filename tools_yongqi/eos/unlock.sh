#!/bin/bash

key=$(cat /data/info/wallet_eos.key)
cleos --url http://127.0.0.1:8889/ wallet unlock --password $key
