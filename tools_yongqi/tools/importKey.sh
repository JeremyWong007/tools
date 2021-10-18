#！/bin/bash

./unlock.sh
source globalInfo.sh
#基金会帐户 account address: T1LTSwa988iJt27BXGCDQtwT6k5rDWZe
tafclient wallet importkey --private-key 5KENnPegq7hiPBZYRuuD8x4QonnqErFWz4gMiSGCNEcRvvb4KJE
#团队帐户 account address: T1ZWdPKoaSCxhUW4KGosys97Gh4dmkzo
tafclient wallet importkey --private-key 5JGdHMeVJc2SpvnY8UPLu4TyxUE3AXQFoxM2pC44hVzvyHKiBYZ
#种子轮帐户 account address: T1mVcBJa8rDASrFRJf2G1jdH9HhaZN6A
tafclient wallet importkey --private-key 5KLuHULoc5W29ULdtaDUmgG9k29QngNdwKmrqFbQWV2SsKPxtV2
#天使轮帐户 account address: T1PWYf9ypEo8PagaWfeqkF8hJB1ERsBk
tafclient wallet importkey --private-key 5KJBtxaU5KA3o5u59i2SRANGvh2otv8N6H4zRBWA4mpFLSkJzN3
#私募帐户 account address: T123QPCKjdeTrprrDjwya67fngMXJrdqY
tafclient wallet importkey --private-key 5K8JvGrUkVDTukZJJmAXYxgjowNrjrxprMNumw1SEvVyjM5xP8W
#ICO帐户 account address: T18otnQRXsMjdrMgLWp7XdbXKL8jgJvB3uQ
tafclient wallet importkey --private-key 5Jk71xYbN7spuCyxu34mdMaAiUtEwCjztaqWziK9o4WAHbTNScM

# import private keys
for((i=0;i<${#private_keys[@]};i++));
do
    PRIV_KEY=${private_keys[i]}
    tafclient wallet importkey --private-key $PRIV_KEY
done