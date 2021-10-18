#! /bin/bash
set -x

echo "############################################################################"
echo "test command start:"
ICO_ACCOUNT="T18otnQRXsMjdrMgLWp7XdbXKL8jgJvB3uQ"

curl --request POST --url http://127.0.0.1:8888/taf/taf_getInfo
curl --request POST --url http://127.0.0.1:8888/taf/taf_getMiners
curl --request POST --url http://127.0.0.1:8888/taf/taf_getMinerSchedule

#计算投票率：
tafclient query form T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T global
tafclient query cryptocurrency stats T1phSrWeGNQQvypVEn7kKM1MJbN6Tbof TAFT
#投票率=total_activated_stake /10000 / supply

#测试rocksdb
#公钥：TAF7u97SYkF1hqQtJADSm3sz6VYReXfSWkLRBBdGEbH6X22TkebGE
#私钥：5K7aoyyXtJJSuS2devN2PedLe5Tinccx2KaK5eonff58onvazm5
#account address: T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN
tafclient wallet importkey --private-key 5K7aoyyXtJJSuS2devN2PedLe5Tinccx2KaK5eonff58onvazm5
tafclient new account TAF7u97SYkF1hqQtJADSm3sz6VYReXfSWkLRBBdGEbH6X22TkebGE
tafclient query account T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN

tafclient transfer $ICO_ACCOUNT T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN "2000.0000 TAFT"
tafclient maker delegatesource T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN "1000.0000 TAFT" "1000.0000 TAFT"
tafclient update contract T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN /data/info/git/taf/kv-test/contracts/kv_map --max-net-usage 30000 -p T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN@active
tafclient send action T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN upsert '[3, "jane.acct1334455" "jane", "doe", "1 main st", "new york", "NY", "USA", "123"]' -p T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN@active
tafclient send action T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN get '[3]' -p T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN@active