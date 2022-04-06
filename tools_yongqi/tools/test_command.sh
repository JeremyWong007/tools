#! /bin/bash
set -x

echo "############################################################################"
echo "test command start:"

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
function test_rocksdb(){
    tafclient wallet importkey --private-key 5K7aoyyXtJJSuS2devN2PedLe5Tinccx2KaK5eonff58onvazm5
    tafclient new account TAF7u97SYkF1hqQtJADSm3sz6VYReXfSWkLRBBdGEbH6X22TkebGE
    tafclient query account T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN

    tafclient transfer T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN "2000.0000 TAFT"
    tafclient maker delegatesource T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN "1000.0000 TAFT" "1000.0000 TAFT"
    #tafclient update contract T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN /data/info/git/taf/kv-test/contracts/kv_map --max-net-usage 30000 -p T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN@active
    #tafclient update contract T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN /data/info/git/taf/build/unittests/test-contracts/kv_bios --max-net-usage 30000 -p T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN@active
    tafclient update contract T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN /data/info/git/taf-ide-2.1/examples/kv_map/build/kv_map --max-net-usage 30000 -p T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN@active
    tafclient send action T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN upsert '[3, "jane.acct1334455" "jane", "doe", "1 main st", "new york", "NY", "USA", "123"]' -p T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN@active
    tafclient send action T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN get '[3]' -p T1Jab9vtJ3uH2eeCDeti1jLpwW3AfkYMuGN@active
}
function test_contract(){
    tafclient wallet importkey --private-key 5KaQvZHjAdVDw9Vj9g75gdZA9moTf63jLp7j1sdk2swfCbRMN9f
    tafclient new account TAF62RicgwQmFVqfCdNWvJirgdDRvp3SjS3dqVMU7i4pPypPUtQyK
    tafclient query account T15LDsm6pUfsCU8dszCn9nxiHHiYULV1WK9

    tafclient transfer T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA T15LDsm6pUfsCU8dszCn9nxiHHiYULV1WK9 "2000.0000 TAFT"
    tafclient maker delegatesource T15LDsm6pUfsCU8dszCn9nxiHHiYULV1WK9 T15LDsm6pUfsCU8dszCn9nxiHHiYULV1WK9 "1000.0000 TAFT" "1000.0000 TAFT"
    tafclient update contract T15LDsm6pUfsCU8dszCn9nxiHHiYULV1WK9 /data/info/git/taf/build/unittests/test-contracts/asserter --max-net-usage 30000 -p T15LDsm6pUfsCU8dszCn9nxiHHiYULV1WK9@active
    
    tafclient send action T15LDsm6pUfsCU8dszCn9nxiHHiYULV1WK9 procassert '[1, "Hello assert"]' -p T15LDsm6pUfsCU8dszCn9nxiHHiYULV1WK9@active
    tafclient send action T15LDsm6pUfsCU8dszCn9nxiHHiYULV1WK9 provereset '[]' -p T15LDsm6pUfsCU8dszCn9nxiHHiYULV1WK9@active
}
test_rocksdb
test_contract
