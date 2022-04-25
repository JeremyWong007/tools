#！/bin/bash

source globalInfo.sh
pkillAndWait mcp
echo "restart mcp"
#nohup ./mcp --daemon --network=3 --data_path=/root/ccn/mcp-mini --witness_account=/root/ccn/mcp-mini/0x1144B522F45265C2DFDBAEE8E324719E63A1694C.json --password=12345678 >> /dev/null 2>&1 &
nohup /root/ccn/git/mcp/build/mcp --daemon --rpc --rpc_control --network=4 --data_path=/root/ccn/localNet/1 --witness --witness_account=/root/ccn/config-file-old/0x1144B522F45265C2DFDBAEE8E324719E63A1694C.json --password=12345678 >> /dev/null 2>&1 &
nohup /root/ccn/git/mcp/build/mcp --daemon --rpc --rpc_control --network=4 --data_path=/root/ccn/localNet/2 --rpc_addr=127.0.0.1 --rpc_port=8766 --port=30607 --witness --witness_account=/root/ccn/config-file-old/0xd11c69cf2a766bee0d7b5186687e70e0ca0530db.json --password=12345678 >> /dev/null 2>&1 &
nohup /root/ccn/git/mcp/build/mcp --daemon --rpc --rpc_control --network=4 --data_path=/root/ccn/localNet/3 --rpc_addr=127.0.0.1 --rpc_port=8767 --port=30608 --witness --witness_account=/root/ccn/config-file-old/0xc086b09411e4c16b90e1b4b32a7f5d34f0f8eee4.json --password=12345678 >> /dev/null 2>&1 &
nohup /root/ccn/git/mcp/build/mcp --daemon --rpc --rpc_control --network=4 --data_path=/root/ccn/localNet/4 --rpc_addr=127.0.0.1 --rpc_port=8768 --port=30609 --witness --witness_account=/root/ccn/config-file-old/0xdb06ba6181c94d4b30ad8f3d8c29737e4222d7e7.json --password=12345678 >> /dev/null 2>&1 &