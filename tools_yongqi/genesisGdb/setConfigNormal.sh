#! /bin/bash
set -u
set -x

#unlock wallet first.
#input keys to wallet

CONTRACT_PATH=$1
echo CONTRACT_PATH is ${CONTRACT_PATH}
sleep 1

tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1bZsTs4uc34x3J2oD63QN2v269w91gU TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T14c7ngQTMQiZjyYVURbJ2HtSeQGDgLP TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1MTdg5DwEHmmjc5RpT6pgvfPbZNrEfj TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1nvgCajfd4wT2osvcDuSVRvAKKX6J6U TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1454ScZPfqvguJLRjaLbHcNMKuQJMiQ TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1VN9KA1CNvfpBfCQnd1Nj1jRhD9W8e4 TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1b7fPJ88wcM8XkgAonbdHLcwdrt1B2K TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1phSrWeGNQQvypVEn7kKM1MJbN6Tbof TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T129byhshcwQjJc2xUgZfa99Gi3x2ayLh TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM
tafclient new sysaccount T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1XmKnz3dLP343BUBarH8QPxkDaz6RfD TAF6Kc7LVUHVxauut2rj8Rwk21mXAYpvLoNsJf3C1vFLFjhGeeHHM

curl --request POST --url http://127.0.0.1:8888/taf/schedule_protocol_feature_activations   -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}'
sleep 1
cd $CONTRACT_PATH
tafclient update contract T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T ./tafsys.boot
tafclient send trx '{"delay_sec":0,"max_cpu_usage_ms":0,"actions":[{"account":"T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T","name":"activate","data":{"feature_digest":"299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"},"authorization":[{"actor":"tafsys","permission":"active"}]}]}'
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

tafclient send action T1phSrWeGNQQvypVEn7kKM1MJbN6Tbof tfcreate '[ "T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T", "3000000000.0000 TAFT" ]' -p T1phSrWeGNQQvypVEn7kKM1MJbN6Tbof@active
tafclient send action T1phSrWeGNQQvypVEn7kKM1MJbN6Tbof tfissue '[ "T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T", "1000000000.0000 TAFT", "memo" ]' -p T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T@active

sleep 1
tafclient update contract T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T ./tafsys.system
exit
tafclient send action T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T tfsetforce '["T14c7ngQTMQiZjyYVURbJ2HtSeQGDgLP", 1]' -p T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T@active
tafclient send action T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T init '["0", "4,TAFT"]' -p T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T@active
