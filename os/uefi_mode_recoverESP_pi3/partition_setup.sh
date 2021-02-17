#!/bin/sh

recoverESP=`blkid | grep "LABEL=\"RECOVERY\"" |awk '{print $1}' | sed 's/.$//'`
drive=`echo $recoverESP | sed 's/.$//'`
echo $recoverESP
echo $drive

if [ -z "$restore" ]; then
mount $recoverESP -o remount,rw || exit 1
mv -F /mnt/EFI /mnt/EFI.old 
mkdir /mnt/EFI
touch /mnt/EFI/ESP.off.pinn || exit 1
sync

fi


#ESP TOGGLE ON
if [ -f /mnt/EFI/ESP.off.pinn ]; then
#umount $recoverESP || exit 1
echo toggle ESP ON
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${drive}
  t
  1
  ef
  a
  1
  w
  q
EOF
parted -s $drive set 1 boot on 
#mount $recoverESP /mnt || exit 1
touch /mnt/EFI/ESP.on.pinn || exit 1
rm /mnt/EFI/ESP.off.pinn || exit 1
partprobe
exit 0
fi



#ESP TOGGLE OFF
if [ -f /mnt/EFI/ESP.on.pinn ]; then
echo toggle ESP OFF
umount $recoverESP || exit 1
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${drive}
  t
  1
  e
  a
  1
  w
  q
EOF
parted -s $drive set 1 boot off
mount $recoverESP /mnt || exit 1
touch /mnt/EFI/ESP.off.pinn || exit 1
rm /mnt/EFI/ESP.on.pinn || exit 1
partprobe
exit 0
fi


exit 1
