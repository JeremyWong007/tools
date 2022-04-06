#! /bin/bash
set -u
set -x

WORK_NODES=$1

#基金会帐户 account address: T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S
tafclient wallet importkey --private-key 5KENnPegq7hiPBZYRuuD8x4QonnqErFWz4gMiSGCNEcRvvb4KJE
tafclient new account TAF8VS2tKPTznw8BntttKxGzCR6rupgQYeh8LmKj7dXNAsMZYj8NJ
tafclient transfer T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S "240000000.0000 TAFT"
AccountFoundation="T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S"

#团队帐户 account address: T1BvMyqRo9BnHKi1DamjF1MwWcGT3EGfrCA  【做为水龙头帐户】
tafclient wallet importkey --private-key 5JGdHMeVJc2SpvnY8UPLu4TyxUE3AXQFoxM2pC44hVzvyHKiBYZ
tafclient new account TAF8Gv9KB3M5QmNu69j7BsGXyYQGFAiQWxK9RRmGrCTLuSUQzRE3o
tafclient transfer T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1BvMyqRo9BnHKi1DamjF1MwWcGT3EGfrCA "180000000.0000 TAFT"

#投资者帐户 account address: T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA
tafclient wallet importkey --private-key 5KLuHULoc5W29ULdtaDUmgG9k29QngNdwKmrqFbQWV2SsKPxtV2
tafclient new account TAF5h8yr8Fuz5XLVcVZL3kYQYaR8bqBJhXK4vFRVG3ThiKDt67Rsw
tafclient transfer T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA "780000000.0000 TAFT"
AccountInvestor="T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA"

#给tafbas抵压cpu和net，保证创建帐户命令得到正确执行
tafclient maker delegatesource T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA T17pFoCekTq9Ukui6jgFhu2QLc9F5tMvJif "500 TAFT" "500 TAFT"

source globalInfo.sh

# create all account and get name
maker_name_array=()
echo "create all account and get name:"
#注意，i=0时未使用，对应于创世节点（创世节点的帐户名为系统帐户）
for((i=1;i<$WORK_NODES;i++));
do
    PUB_KEY=${public_keys[i]}
    RSP=`tafclient new account $PUB_KEY`
    RESULT=`echo $RSP | awk -F 'account address: ' '{print $2}' `
    # if is empty, exit
    maker_name_array[i]=$RESULT
    echo $i $RESULT
done

# transfer to work node
for((i=1;i<$WORK_NODES;i++));
do
    NAME=${maker_name_array[i]}
    ASSET=`echo "1+0.0001*$i" | bc`
    tafclient maker delegatesource $AccountFoundation $NAME "1 TAFT" "1 TAFT"
    tafclient transfer $AccountFoundation $NAME "$ASSET TAFT"
    #ASSET_HALF=`echo "$ASSET-0.5" | bc`
    tafclient maker delegatesource $NAME $NAME "$ASSET TAFT" "0.0000 TAFT"
    tafclient maker regmaker $NAME TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://$NAME.com
    tafclient maker votemakers prods $NAME $NAME
done

tafclient maker delegatesource $AccountInvestor $AccountInvestor "120000000.0000 TAFT" "120000000.0000 TAFT"
#maker_name_array[1]帐户：
tafclient maker votemakers prods  $AccountInvestor ${maker_name_array[1]}

tafclient maker listmakers