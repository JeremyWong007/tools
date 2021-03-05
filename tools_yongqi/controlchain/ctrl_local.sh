#！/bin/bash

ctrlfile=$1
echo execute local $1
cd ~/info/git/biosboot
cd genesis
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