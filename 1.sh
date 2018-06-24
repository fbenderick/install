# format partitions
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2

# install
mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
pacstrap /mnt base base-devel

genfstab -U -p /mnt >> /mnt/etc/fstab

# copy install scripts
# cp /root/install/20-chroot.sh /mnt/root/
# arch-chroot /mnt /root/20-chroot.sh
# reboot
