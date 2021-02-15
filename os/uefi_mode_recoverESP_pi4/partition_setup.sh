#!/bin/sh

#drive=`echo $part1 | sed 's/.$//'`

drive=`blkid | grep "LABEL=\"RECOVERY\"" |awk '{print $1}' | sed 's/.$//' | sed 's/.$//'`
echo $drive


recoverESP=$drive\1
umount $recoverESP



sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${drive}
  t
  1
  ef
  a
  1
  w
  q
EOF

parted -s $drive name 1 recoverESP
mount $recoverESP






exit 0
