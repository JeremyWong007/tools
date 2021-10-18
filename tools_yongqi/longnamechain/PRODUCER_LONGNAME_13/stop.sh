#!/bin/bash
DATADIR="./blockchain/"

if [ -f $DATADIR"/tafd.pid" ]; then
pid=`cat $DATADIR"/tafd.pid"`
echo $pid
kill $pid
rm -r $DATADIR"/tafd.pid"
echo -ne "Stoping Node"
while true; do
[ ! -d "/proc/$pid/fd" ] && break
echo -ne "."
sleep 1
done
echo -ne "\rNode Stopped. \n"
fi
