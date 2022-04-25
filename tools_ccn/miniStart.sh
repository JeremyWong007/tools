#！/bin/bash

source globalInfo.sh
pkillAndWait mcp
echo "restart mcp"
#nohup ./mcp --daemon --network=3 --data_path=/root/ccn/mcp-mini --witness_account=/root/ccn/mcp-mini/0x1144B522F45265C2DFDBAEE8E324719E63A1694C.json --password=12345678 >> /dev/null 2>&1 &
nohup /root/ccn/git/mcp/build/mcp --daemon --rpc --rpc_control --network=4 --data_path=/root/ccn/mcp-mini --witness --witness_account=/root/ccn/config-file-old/0x1144B522F45265C2DFDBAEE8E324719E63A1694C.json --password=12345678 >> /dev/null 2>&1 &