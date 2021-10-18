#!/bin/bash
set -u
#set -x


CURRENT_DIR="$(cd "$(dirname "$0")"; pwd)"
cd $CURRENT_DIR
./unlock.sh

source globalInfo.sh

AccountFoundation="T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S"
AccountInvestor="T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA"
function createCompanyAccount(){
    #基金会帐户 account address: T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S
    tafclient wallet importkey --private-key 5KENnPegq7hiPBZYRuuD8x4QonnqErFWz4gMiSGCNEcRvvb4KJE
    tafclient new account TAF8VS2tKPTznw8BntttKxGzCR6rupgQYeh8LmKj7dXNAsMZYj8NJ
    tafclient transfer T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S "240000000.0000 TAFT"
    #AccountFoundation="T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S"
    #tafclient maker delegatesource $AccountFoundation $AccountFoundation "100.0000 TAFT" "100.0000 TAFT"

    #团队帐户 account address: T1BvMyqRo9BnHKi1DamjF1MwWcGT3EGfrCA
    tafclient wallet importkey --private-key 5JGdHMeVJc2SpvnY8UPLu4TyxUE3AXQFoxM2pC44hVzvyHKiBYZ
    tafclient new account TAF8Gv9KB3M5QmNu69j7BsGXyYQGFAiQWxK9RRmGrCTLuSUQzRE3o
    tafclient transfer T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1BvMyqRo9BnHKi1DamjF1MwWcGT3EGfrCA "180000000.0000 TAFT"

    #投资者帐户 account address: T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA
    tafclient wallet importkey --private-key 5KLuHULoc5W29ULdtaDUmgG9k29QngNdwKmrqFbQWV2SsKPxtV2
    tafclient new account TAF5h8yr8Fuz5XLVcVZL3kYQYaR8bqBJhXK4vFRVG3ThiKDt67Rsw
    tafclient transfer T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA "780000000.0000 TAFT"
    #AccountInvestor="T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA"
    #sleep 1
}

function configFirst16Host(){
    echo "configFirst16Host in"
    for((i=0;i<16;i++));
    do
        PUB_KEY=${public_keys[i]}
        RSP=`tafclient new account $PUB_KEY`
        NAME=`echo $RSP | awk -F 'account address: ' '{print $2}' `
        # if is empty, exit
        echo $i $NAME
        
        ASSET=`echo "0.5+0.0001*$i" | bc`
        tafclient transfer $AccountFoundation $NAME "$ASSET TAFT"
        tafclient maker delegatesource $NAME $NAME "$ASSET TAFT" "0.5000 TAFT"
        tafclient maker regmaker $NAME TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://$NAME.com
        tafclient maker votemakers prods $NAME $NAME
    done
    
    tafclient maker delegatesource $AccountInvestor $AccountInvestor "120000000.0000 TAFT" "120000000.0000 TAFT"
    #public_keys[0]对应帐户：T1Gygra5GoPAg5cAN6g7CKbPsLFmrJvSyXo
    tafclient maker votemakers prods  $AccountInvestor T1Gygra5GoPAg5cAN6g7CKbPsLFmrJvSyXo
    tafclient maker listmakers
}

declare -A AliHostNumPart2
AliHostNumPart2["121.41.193.65"]=${AliHostNum["121.41.193.65"]}
AliHostNumPart2["121.41.197.161"]=${AliHostNum["121.41.197.161"]}
AliHostNumPart2["121.41.197.238"]=${AliHostNum["121.41.197.238"]}
AliHostNumPart2["121.41.197.97"]=${AliHostNum["121.41.197.97"]}
AliHostNumPart2["121.41.199.181"]=${AliHostNum["121.41.199.181"]}
function configAliPart2Host(){
    for i in ${AliHostNumPart2[@]};
    do
        echo $i
        echo ${public_keys[164]}
        PUB_KEY=${public_keys[i]}
        RSP=`tafclient new account $PUB_KEY`
        NAME=`echo $RSP | awk -F 'account address: ' '{print $2}' `
        # if is empty, exit
        echo $i $NAME
        
        ASSET=`echo "0.5+0.0001*$i" | bc`
        tafclient transfer $AccountFoundation $NAME "$ASSET TAFT"
        tafclient maker delegatesource $NAME $NAME "$ASSET TAFT" "0.5000 TAFT"
        tafclient maker regmaker $NAME TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://$NAME.com
        tafclient maker votemakers prods $NAME $NAME
    done
    tafclient maker listmakers
}

function configYmxPart2Host(){
    for i in ${YamaxunHostNum["3.115.1.53"]};
    do
        echo $i
        PUB_KEY=${public_keys[i]}
        RSP=`tafclient new account $PUB_KEY`
        NAME=`echo $RSP | awk -F 'account address: ' '{print $2}' `
        # if is empty, exit
        echo $i $NAME
        
        ASSET=`echo "0.5+0.0001*$i" | bc`
        tafclient transfer $AccountFoundation $NAME "$ASSET TAFT"
        tafclient maker delegatesource $NAME $NAME "$ASSET TAFT" "0.5000 TAFT"
        tafclient maker regmaker $NAME TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://$NAME.com
        tafclient maker votemakers prods $NAME $NAME
    done
    tafclient maker listmakers
}

#createCompanyAccount
#configAliPart2Host
#configFirst16Host