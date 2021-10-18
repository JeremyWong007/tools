#！/bin/bash

set -u

if [[ $0 =~ ^\/.* ]]    #判断当前脚本是否为绝对路径，匹配以/开头下的所有
then
  script=$0
else
  script=$(pwd)/$0
fi
script=`readlink -f $script`   #获取文件的真实路径
script_path=${script%/*}     #获取文件所在的目录
realpath=$(readlink -f $script_path)   #获取文件所在目录的真实路径
#echo $script
#echo $script_path
#echo $realpath
cd $script_path

ctrlfile=$1
echo execute local $1
cd ../genesis
./${ctrlfile}
cd ../accountnum11
./${ctrlfile}
cd ../accountnum12
./${ctrlfile}
cd ../accountnum13
./${ctrlfile}

echo ""
echo "ps -e | grep nod"
ps -e | grep nod
