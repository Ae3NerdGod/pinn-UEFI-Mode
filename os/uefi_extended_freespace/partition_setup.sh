#!/bin/sh
#supports_backup in PINN
if [ -z "$restore" ]; then

echo "please re-run partition setup for this \"os\" -- extended freespace is two-step process " >>/tmp/debug
exit 0
fi

partprobe
part=`blkid | grep "LABEL=\"DELTHIS\"" | awk '{print $1}' | sed 's/.$//'`
drive=`echo -n $part |  sed 's/.$//'`

partnum=`echo -n $part | tail -c 1`

settingspart=`blkid | grep "LABEL=\"SETTINGS\"" |awk '{print $1}' | sed 's/.$//' `
echo drive is $drive part is $part partnum is $partnum settingspart is $settingspart

sync

umount /settings 
parted -s $drive rm $partnum 
mount $settingspart /settings 


exit 0


