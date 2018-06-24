echo 'local' > /etc/hostname
mkinitcpio -p linux

echo 'Setup root password':
passwd

# install neovim, can't live with vi :\
pacman -Suy neovim

# create locales
nvim /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

# setting up console font
echo FONT=latarcyrheb-sun32 > /etc/vconsole.conf

# set up time
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc --utc

# BOOTLOADER
# grub -- for gpt
# pacman -Suy grub
# grub-install --target=i386-pc /dev/sda
# grub-mkconfig -o /boot/grub/grub.cfg

# Intel microcode for UEFI
pacman -Suy dosfstools intel-ucode
bootctl --path=/boot install
# create boot entry with default content
mkdir -p /boot/loader
mkdir -p /boot/loader/entries
rm /boot/loader/entries/arch.conf
echo 'title Arch Linux' > /boot/loader/entries/arch.conf
echo 'linux /vmlinuz-linux' >> /boot/loader/entries/arch.conf
echo 'initrd /intel-ucode.img' >> /boot/loader/entries/arch.conf
echo 'initrd /initramfs-linux.img' >> /boot/loader/entries/arch.conf
echo 'options root=PARTUUID= rw quiet' >> /boot/loader/entries/arch.conf
blkid | awk '{print $1" "$(NF)}' >> /boot/loader/entries/arch.conf
nvim /boot/loader/entries/arch.conf
echo "default arch" > /boot/loader/loader.conf
read -p "It seems loader succesfully installed..."

# create user
useradd --create-home user
passwd user

# add user to sudoers
pacman -Suy sudo
EDITOR=nvim visudo

# need git to clone boostrap repo
echo 'Base installation finished'
echo 'Now, reboot, install openssh, start daemon and orchestrate bootstrap with Ansible'
read -p "Press enter to continue"
