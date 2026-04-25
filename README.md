# dotfiles

My dotfiles for Arch Linux — dwm, st, zsh, neovim, mpd, neomutt, and more.

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
.config/        git, lf, mpd, msmtp, mutt, ncmpcpp, notmuch, shell, x11, zsh
.local/         bin, share — scripts and local data
laptop/         xorg touchpad config, udev rules
hooks/          pacman hooks (sbctl kernel signing)
.mbsyncrc       isync/mbsync email config
.notmuch-config notmuch mail indexer config
.xprofile       X startup (keyboard, wallpaper, picom, dwmblocks, etc.)
.zprofile       login shell — env vars, XDG dirs, PATH, startx
setup.sh        full post-install setup script
sync.sh         stow dotfiles into place
```

## Usage

```sh
git clone https://github.com/aleksav013/dotfiles ~/mygit/dotfiles
cd ~/mygit/dotfiles
./sync.sh       # stow everything into ~
./setup.sh      # install packages, build suckless tools, configure system
```

---

## Arch Linux Install — LUKS + BTRFS + Snapper

### 1. Partitioning

```sh
fdisk /dev/sda
# sda1 = 512M, type EFI System
# sda2 = 512M, type Linux filesystem  (boot)
# sda3 = rest,  type Linux filesystem (root)
```

### 2. Encryption + Filesystem

```sh
mkfs.fat -F32 /dev/sda1
mkfs.ext4 -L BOOT /dev/sda2

cryptsetup luksFormat /dev/sda3
cryptsetup open /dev/sda3 cryptroot

mkfs.btrfs -L arch /dev/mapper/cryptroot
```

### 3. Create Subvolumes

```sh
mount /dev/mapper/cryptroot /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var_log
btrfs subvolume create /mnt/@var_cache
btrfs subvolume create /mnt/@var_tmp

umount /mnt
```

### 4. Mount Everything

```sh
OPTS="noatime,compress=zstd:1,space_cache=v2,discard=async"

mount -o $OPTS,subvol=@              /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{boot,home,var/log,var/cache,var/tmp}
mount /dev/sda2 /mnt/boot
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
mount -o $OPTS,subvol=@home          /dev/mapper/cryptroot /mnt/home
mount -o $OPTS,subvol=@var_log       /dev/mapper/cryptroot /mnt/var/log
mount -o $OPTS,subvol=@var_cache     /dev/mapper/cryptroot /mnt/var/cache
mount -o $OPTS,subvol=@var_tmp       /dev/mapper/cryptroot /mnt/var/tmp
```

### 5. Install Base System

```sh
pacstrap /mnt base base-devel linux linux-firmware \
  git networkmanager vim grub efibootmgr os-prober \
  btrfs-progs cryptsetup
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
```

### 6. Chroot + System Config

```sh
arch-chroot /mnt

passwd
useradd -m -G wheel aleksa
passwd aleksa
EDITOR=vim visudo
# Uncomment: %wheel ALL=(ALL:ALL) ALL

echo "arch" > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain arch
EOF

ln -sf /usr/share/zoneinfo/Europe/Belgrade /etc/localtime
hwclock --systohc

vim /etc/locale.gen
# Uncomment en_US.UTF-8 UTF-8 (and others as needed)
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

systemctl enable NetworkManager
```

### 7. Mkinitcpio — Add Encryption Hook

Edit `/etc/mkinitcpio.conf`, set HOOKS to:

```
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)
```

Then regenerate:

```sh
mkinitcpio -P
```

### 8. GRUB — Configure for LUKS

```sh
blkid /dev/sda3   # note the UUID of the LUKS partition
vim /etc/default/grub
```

Set:

```
GRUB_CMDLINE_LINUX="cryptdevice=UUID=YOUR-UUID:cryptroot root=/dev/mapper/cryptroot"
```

Install and generate:

```sh
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

### 9. Exit + Reboot

```sh
exit
umount -R /mnt
poweroff
```

### 10. Post-Boot: Secure Boot (sbctl)

```sh
sudo pacman -S sbctl
sudo sbctl create-keys

# Reboot → UEFI → Secure Boot → Clear keys (Setup Mode)
# Do NOT enable Secure Boot yet. Boot back into Arch, then:

sudo sbctl enroll-keys --microsoft
sudo sbctl sign -s /boot/efi/EFI/GRUB/grubx64.efi
sudo sbctl sign -s /boot/vmlinuz-linux
sudo sbctl verify

# Reboot → UEFI → Enable Secure Boot
```

The pacman hook `hooks/99-sbctl.hook` auto-signs the kernel on updates.

### 11. Post-Boot: Snapper (Root Snapshots)

```sh
sudo pacman -S snapper
sudo snapper -c root create-config /
sudo snapper -c root create --description "clean install"
```

### Post-Boot: Setup

```sh
git clone https://github.com/aleksav013/dotfiles ~/mygit/dotfiles
cd ~/mygit/dotfiles
./sync.sh
./setup.sh

# Snapper
snapper -c root list                    # list snapshots
snapper -c root create --description "" # manual snapshot

# BTRFS
btrfs filesystem usage /
```
