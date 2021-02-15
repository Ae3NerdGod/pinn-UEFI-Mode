#!/bin/sh

#drive=`echo $part1 | sed 's/.$//'`


part=`blkid | grep "LABEL=\"DELTHIS\"" | awk '{print $1}' | sed 's/.$//'`
drive=`echo -n $part |  sed 's/.$//'`

partnum=` echo -n $part | tail -c 1 `

settingspart=`blkid | grep "LABEL=\"SETTINGS\"" |awk '{print $1}' | sed 's/.$//' `
echo drive is $drive part is $part partnum is $partnum settingspart is $settingspart

umount /settings
sleep 1
parted -s $drive rm $partnum
sleep 1
mount $settingspart /settings






exit 0
