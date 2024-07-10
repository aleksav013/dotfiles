# dotfiles
My dotfiles

```
fdisk /dev/vda
mkfs.fat -F32 /dev/vda1
mkfs.ext4 /dev/vda2

mount /dev/vda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/vda1 /mnt/boot/efi

pacstrap /mnt base base-devel linux linux-firmware git networkmanager vim grub efibootmgr os-prober
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt
passwd
useradd -m -G wheel aleksa
passwd aleksa
vim /etc/sudoers
vim /etc/hosts
echo "arch" > /etc/hostname
ln -sf /usr/share/zoneinfo/Europe/Belgrade /etc/localtime
hwclock --systohc
systemctl enable NetworkManager
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

exit
umount -R /mnt
poweroff
```
