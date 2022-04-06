#!/bin/bash
#set -u
#set -x
set +e
./unlock.sh
source globalInfo.sh

declare -A accountsAndKeys
declare -A accountsAndKeys2
declare -a accountVector

function createTafAccount(){

    keys=`tafclient new key --to-console | awk '{print $3}'`
    private_key=`echo $keys | awk '{print $1}'`
    public_key=`echo $keys | awk '{print $2}'`
    account=`tafclient new account $public_key | grep "account address:"`
    if [ "$account" == "" ]; then
        echo "Fail to create account"
    else
    	account=`echo $account | awk '{print $3}'`
    	accountVector+=($account)
    	accountsAndKeys[$account]=$private_key
    	tafclient wallet importkey --private-key $private_key
    	#echo $account ${accountsAndKeys[$account]}

    	tafclient transfer T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S $account "1 TAFT"
    	tafclient maker delegatesource $account $account "0.1 TAFT" "0.1 TAFT"
    fi
}

function createTafAccounts(){
    num=$1
    echo "createTafAccounts num =" $num
    for((i=0; i<$num; i++))
    do
        createTafAccount
        echo "accountsAndKeys[$account]=$private_key/$public_key" >> accountsAndKeys.src
    done
}

function delegatesource(){
    init
    for acc in ${!accountsAndKeys[@]}; do
        tafclient maker delegatesource $acc $acc "0.1 TAFT" "0.1 TAFT"
    done
}

function test_transfer(){
    transferTimes=$1
    echo "test_transfer num =" $transferTimes
    
    accountVectorSize=${#accountVector[@]}
    for((i=0;i<$transferTimes;i++));
    do
        random 0 $accountVectorSize
        accountFrom=${accountVector[$randomValue]}
        random 0 $accountVectorSize
        accountTo=${accountVector[$randomValue]}
        random 1 100000
        asset=`echo $randomValue/1000 | bc`
        asset_inter=`expr $randomValue / 1000`
        asset_deci=`expr $randomValue % 1000`
        if [ "$asset_deci" -lt "10" ]; then
            asset="$asset_inter.00$asset_deci"
        elif [ "$asset_deci" -lt "100" ]; then
            asset="$asset_inter.0$asset_deci"
        else
            asset="$asset_inter.$asset_deci"
        fi
        tafclient transfer $accountFrom $accountTo "$asset TAFT"
    done
}

function createTafAccountsHuge(){
    while [ true ]
    do
        if [ ${#accountsAndKeys[@]} -le 10000 ]; then
            random 0 10
            createTafAccounts $randomValue
        else
            random 0 100
            if [ $randomValue -ge 95 ]; then
                createTafAccounts 1
            fi
        fi

        if [ ${#accountsAndKeys[@]} -ge 200 ]; then
            random 100 200
            test_transfer $randomValue
        fi

        #sleep 0.3
    done
}

function createTafAccountsFromImport(){
    source accountsAndKeys.src
    for keys in ${accountsAndKeys[@]}; do
        tafclient new account ${keys#*/}
    done
}

function importAccountskey(){
    source accountsAndKeys.src
    for keys in ${accountsAndKeys[@]}; do
        echo ${keys%/*}
    	tafclient wallet importkey --private-key ${keys%/*}
    done
}

function random(){
    min=$1;
    max=$2-$1;
    num=$(date +%N);
    num=`echo $num | sed -r 's/^0+//'`
    ((randomValue=num%max+min));
    #进行求余数运算即可
    #echo "randomValue:" $randomValue;
}

#T17pFoCekTq9Ukui6jgFhu2QLc9F5tMvJif为tafbas，创建帐户需要抵压资源
#tafclient maker delegatesource T1BvMyqRo9BnHKi1DamjF1MwWcGT3EGfrCA T17pFoCekTq9Ukui6jgFhu2QLc9F5tMvJif "500 TAFT" "500 TAFT"
function init(){
    if [ -e accountsAndKeys.src ]; then
        source accountsAndKeys.src
    fi
    for acc in ${!accountsAndKeys[@]}; do
        accountVector+=($acc)
    done
}
function runSimulation(){
    echo "runSimulation in"
    createTafAccountsHuge
    echo "runSimulation out"
}
function createTafAccount2(){
    keys=`tafclient new key --to-console | awk '{print $3}'`
    private_key=`echo $keys | awk '{print $1}'`
    public_key=`echo $keys | awk '{print $2}'`
    account=`tafclient new account $public_key | grep "account address:"`
    if [ "$account" == "" ]; then
        echo "Fail to create account"
    else
    	account=`echo $account | awk '{print $3}'`
    	accountVector+=($account)
    	accountsAndKeys[$account]=$private_key
    	tafclient wallet importkey --private-key $private_key
    	#echo $account ${accountsAndKeys[$account]}

    	tafclient transfer T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S $account "10000 TAFT"
    	tafclient maker delegatesource $account $account "40 TAFT" "40 TAFT"
    fi
}
function importAccountskey2(){
    for keys in ${accountsAndKeys2[@]}; do
        echo ${keys%/*}
    	tafclient wallet importkey --private-key ${keys%/*}
    done
}
function createTafAccounts2(){
    num=$1
    echo "createTafAccounts2 num =" $num
    for((i=0; i<$num; i++))
    do
        createTafAccount2
        echo "accountsAndKeys2[$account]=$private_key/$public_key" >> accountsAndKeys2.src
        #sleep 1
    done
}
function initHighTransfer(){
    echo "initHighTransfer in"
    if [ -e accountsAndKeys2.src ]; then
        source accountsAndKeys2.src
        importAccountskey2
    else
        createTafAccounts2 200
    fi
    for acc in ${!accountsAndKeys2[@]}; do
        accountVector+=($acc)
    done
    echo "initHighTransfer over"
}
function runHighTransfer(){
    initHighTransfer
    sleep 1
    while [ true ]
    do
        test_transfer 200
    done
}
function giveMoreBalance(){
    echo "giveMoreBalance in"
    initHighTransfer
    for acc in ${accountVector[@]}; do
        tafclient transfer T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S $acc "9900 TAFT"
    done
    echo "giveMoreBalance over"
}
#giveMoreBalance

#抵压投票以出块相关设置
function stakeAndVote(){
    # create all account and get name
    AccountFoundation="T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S"
    numStart=$1
    numEnd=$2
    maker_name_array=()
    echo "create all account and get name:"
    for((i=$numStart;i<$numEnd;i++));
    do
        PUB_KEY=${public_keys[i]}
        RSP=`tafclient new account $PUB_KEY`
        RESULT=`echo $RSP | awk -F 'account address: ' '{print $2}' `
        # if is empty, exit
        maker_name_array[i]=$RESULT
        echo $i $RESULT
    done

    # transfer to work node
    for((i=$numStart;i<$numEnd;i++));
    do
        NAME=${maker_name_array[i]}
        ASSET=`echo "1+0.0001*$i" | bc`
        tafclient transfer $AccountFoundation $NAME "$ASSET TAFT"
        #ASSET=`echo "$ASSET-0.5" | bc`
        tafclient maker delegatesource $AccountFoundation $NAME "1 TAFT" "1 TAFT"
        tafclient maker delegatesource $NAME $NAME "$ASSET TAFT" "0 TAFT"
        tafclient maker regmaker $NAME TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://$NAME.com
        tafclient maker votemakers prods $NAME $NAME
    done
}

#144 T17mBpBndyur5P7mtiF8ui8XtBxr4HTsCKh
function stakeAndVoteAli(){
    AccountFoundation="T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S"
    echo "create all account and get name:"
    for i in ${AliHostNum[@]}; do
        echo num is $i
        PUB_KEY=${public_keys[i]}
        RSP=`tafclient new account $PUB_KEY`
        accountAddress=`echo $RSP | awk -F 'account address: ' '{print $2}' `
        # if is empty, exit
        echo $i $accountAddress

        NAME=${accountAddress}
        ASSET=`echo "1+0.0001*$i" | bc`
        tafclient transfer $AccountFoundation $NAME "$ASSET TAFT"
        #ASSET=`echo "$ASSET-0.5" | bc`
        tafclient maker delegatesource $AccountFoundation $NAME "1 TAFT" "1 TAFT"
        tafclient maker delegatesource $NAME $NAME "$ASSET TAFT" "0 TAFT"
        tafclient maker regmaker $NAME TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://$NAME.com
        tafclient maker votemakers prods $NAME $NAME
    done
}
function regYamaxun(){
    AccountFoundation="T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S"
    echo "create all account and get name:"
    for i in ${YamaxunHostNum[@]}; do
        echo num is $i
        PUB_KEY=${public_keys[i]}
        RSP=`tafclient new account $PUB_KEY`
        accountAddress=`echo $RSP | awk -F 'account address: ' '{print $2}' `
        # if is empty, exit
        echo $i $accountAddress

        NAME=${accountAddress}
        ASSET=`echo "1+0.0001*$i" | bc`
        tafclient transfer $AccountFoundation $NAME "$ASSET TAFT"
        #ASSET=`echo "$ASSET-0.5" | bc`
        tafclient maker delegatesource $AccountFoundation $NAME "1 TAFT" "1 TAFT"
        tafclient maker delegatesource $NAME $NAME "$ASSET TAFT" "0 TAFT"
        tafclient maker regmaker $NAME TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://$NAME.com
        #tafclient maker votemakers prods $NAME $NAME
    done
}
#stakeAndVoteAli
#stakeAndVote 21 22

function usage() {
    echo "Usage:"
    echo " ./ctrlChain.sh <optstring> <parameters>"
    echo ""
    echo "Exapmple:"
    echo "./ctrlChain.sh --importAccountskey"
    echo "nohup ./ctrlChain.sh --runSimulation &"
    echo "nohup ./ctrlChain.sh --runHighTransfer &"
    exit 1
}

ARGS=`getopt -o h --long runSimulation,importAccountskey,runHighTransfer -n 'ctrlChain.sh' -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

#将规范化后的命令行参数分配至位置参数（$1,$2,...)
eval set -- "${ARGS}"
while true
do
    case "$1" in
        --runSimulation)
            init
            runSimulation
            shift
            ;;
        --importAccountskey)
            importAccountskey
            shift
            ;;
        --runHighTransfer)
            runHighTransfer
            shift
            ;;
        --)
            shift
            break
            ;;
        -h)
            usage
            ;;
        *)
            echo "Internal error!"
            exit 1
            ;;
    esac
done

#delegatesource
