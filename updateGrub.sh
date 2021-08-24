#!/bin/bash

read -s -p "Passphrase: "  userPass

udisksctl unlock -b /dev/nvme0n1p2 --key-file <(echo -n $userPass)
diskPath=$(fdisk -l | grep -Po '(\/dev\/mapper[\w\/-]*)')

mount $diskPath /mnt
mount /dev/nvme0n1p3 /mnt/boot
for i in /dev /dev/pts /proc /sys /sys/firmware/efi/efivars /run; do sudo mount -B $i /mnt$i; done
mount /dev/nvme0n1p3 /mnt/boot/efi

chroot /mnt /bin/bash <<"EOT"
update-grub
exit
echo $$
EOT
