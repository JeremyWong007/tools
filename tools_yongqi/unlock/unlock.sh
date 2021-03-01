#!/bin/bash

key=$(cat ~/info/wallet.key)
cltaf wallet unlock --password $key
