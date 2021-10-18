#! /bin/bash
set -u
set -x

#公钥TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
tafclient wallet importkey --private-key 5JLrjLzKiWvecrUkBBPEBm4Wt8F7ECygLNnLhhLW64fCGP5RUvH

CONTRACT_PATH=$1
echo CONTRACT_PATH is ${CONTRACT_PATH}
sleep 1
#tafsys.bpay 
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1bZsTs4uc34x3J2oD63QN2v269w91gU TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
#tafsys.msig 
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T14c7ngQTMQiZjyYVURbJ2HtSeQGDgLP TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
#tafsys.names 
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1MTdg5DwEHmmjc5RpT6pgvfPbZNrEfj TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
#tafsys.ram 
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1nvgCajfd4wT2osvcDuSVRvAKKX6J6U TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
#tafsys.ramfee 
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1454ScZPfqvguJLRjaLbHcNMKuQJMiQ TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
#tafsys.saving 
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1VN9KA1CNvfpBfCQnd1Nj1jRhD9W8e4 TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
#tafsys.stake 
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1b7fPJ88wcM8XkgAonbdHLcwdrt1B2K TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
#tafsys.token 
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1phSrWeGNQQvypVEn7kKM1MJbN6Tbof TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
#tafsys.vpay 
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T129byhshcwQjJc2xUgZfa99Gi3x2ayLh TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
#tafsys.rex 
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1XmKnz3dLP343BUBarH8QPxkDaz6RfD TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM

curl --request POST --url http://127.0.0.1:8888/taf/schedule_protocol_feature_activations   -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}'
sleep 1
cd $CONTRACT_PATH
tafclient update contract T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T ./tafsys.boot
tafclient send trx '{"delay_sec":0,"max_cpu_usage_ms":0,"actions":[{"account":"T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T","name":"activate","data":{"feature_digest":"299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"},"authorization":[{"actor":"T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T","permission":"active"}]}]}'
sleep 1
# KV_DATABASE
tafclient send action T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T activate '["825ee6288fb1373eab1b5187ec2f04f6eacb39cb3a97f356a07c91622dd61d16"]' -p T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T@active
# ACTION_RETURN_VALUE
tafclient send action T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T activate '["c3a6138c5061cf291310887c0b5c71fcaffeab90d5deb50d3b9e687cead45071"]' -p T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T@active
# BLOCKCHAIN_PARAMETERS
tafclient send action T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T activate '["5443fcf88330c586bc0e5f3dee10e7f63c76c00249c87fe4fbf7f38c082006b4"]' -p T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T@active
sleep 1

tafclient update contract T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T ./tafsys.bios
tafclient send action T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T setkvparams '[{"max_key_size":64, "max_value_size":1024, "max_iterators":128}]' -p T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T@active

tafclient update contract T1phSrWeGNQQvypVEn7kKM1MJbN6Tbof ./tafsys.token/
tafclient update contract T14c7ngQTMQiZjyYVURbJ2HtSeQGDgLP ./tafsys.msig/

tafclient send action T1phSrWeGNQQvypVEn7kKM1MJbN6Tbof tfcreate '[ "T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T", "2000000000.0000 TAFT" ]' -p T1phSrWeGNQQvypVEn7kKM1MJbN6Tbof@active
tafclient send action T1phSrWeGNQQvypVEn7kKM1MJbN6Tbof tfissue '[ "T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T", "1200000000.0000 TAFT", "memo" ]' -p T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T@active
sleep 1
tafclient update contract T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T ./tafsys.system
tafclient send action T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T tfsetforce '["T14c7ngQTMQiZjyYVURbJ2HtSeQGDgLP", 1]' -p T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T@active
tafclient send action T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T init '["0", "4,TAFT"]' -p T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T@active

#TDC帐户 account address: T13LnEBUvaLK9iwyt93pCitDiSZ8FXypn6X
tafclient wallet importkey --private-key 5J36WLBHA4hxPyXhDzNWft6XkLytJFN1Viy5HgQvkpoenzpeAJd
tafclient new account TAF6zQRkAJQLjSrZtqMWXXpWNSidBwebftZZEhwyusiyz8RRVnmS1

#存储帐户 account address: T17wkH4s6V3FQ9pV1qafnGyKmPMoGt1TeFw
tafclient wallet importkey --private-key 5KKgyueWB5fCSX8Fm1A23ToddmCoyVEJLrSMVdSe81aLLfzhMfb
tafclient new account TAF85asV3Km7S3FYf2DV7ko5XHNgsxBG5G26P2mP7uuy5HPZd27xW

#矿池帐户 account address: T1Mxk7uNLMzSGdkkKmMo24Bn4PWy86AfJho
tafclient wallet importkey --private-key 5JLonxa8nJTQXfkmeg4Lc8ZgnbWdhx2XobsKdg2MPDdTdsJnZAT
tafclient new account TAF77Y3nQ7nrFaqJVJAiokMfPUNVjrXLrdsevXSy1u5Csy1eL6nLS

#生态开发者帐户 account address: T1B4SjNG551jNg36cbJnwQxL6fM2wiyVFy7
tafclient wallet importkey --private-key 5JLz1MvexLZyz6geh5WC5o6xc5duDqp2WKYqYjdGoq9sap6hk3t
tafclient new account TAF8XN4Z7LLdzr9GtRZpUAVKCELi5A2DC8evjPqLvzB3hp2DzRk8M