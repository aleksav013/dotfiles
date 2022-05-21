#!/bin/sh

## setup script for artix linux with my dotfiles

# artix repos
sudo pacman --noconfirm -Syu acpilight alsa-utils archlinux-keyring \
archlinux-mirrorlist doas git htop maim man-db mpd mpv neofetch neovim npm \
pulseaudio pulseaudio-alsa xclip xorg-server xorg-xinit zsh

# doas.conf
sudo -- sh -c 'printf "permit persist :wheel\n" > /etc/doas.conf'
doas pacman --noconfirm -Rns sudo

# arch repos
doas cp -r ./artix/pacman.conf /etc/
doas pacman --noconfirm -Syu ccls librewolf ncmpcpp pamixer stow sxiv unclutter \
xcompmgr xwallpaper yay zathura zathura-pdf-mupdf

# change shell to zsh
doas chsh -s "$(which zsh)" "$USER"
mkdir -p ~/.cache/zsh
doas mkdir -p /opt/aleksa/usr/bin

# change locale and LANG
doas -- sh -c 'printf "en_US.UTF-8 UTF-8\nsr_RS@latin UTF-8\nsr_RS UTF-8" >> /etc/locale.gen'
doas locale-gen
doas -- sh -c 'printf "LANG=en_US.UTF-8" > /etc/locale.conf'


# My git repos
cd || exit
mkdir -p mygit
cd mygit || exit

git clone https://github.com/aleksav013/dwm
cd dwm || exit
doas make clean install
cd ..
git clone https://github.com/aleksav013/dmenu
cd dmenu || exit
doas make clean install
cd ..
git clone https://github.com/aleksav013/st
cd st || exit
doas make clean install
cd ..
git clone https://github.com/aleksav013/dwmblocks
cd dwmblocks || exit
doas make clean install
cd ..
git clone https://github.com/aleksav013/dotfiles
cd dotfiles || exit
./sync.sh
cd ..
git clone https://github.com/aleksav013/nvim
cd nvim || exit
./sync.sh

# Repos i use
cd || exit
mkdir -p git
cd git || exit

git clone https://github.com/ujjwal96/xwinwrap
cd xwinwrap || exit
doas make
doas make install
make clean


# AUR
yay --noremovemake --nocleanafter -S lf-bin libxft-bgra-git \
nerd-fonts-jetbrains-mono

# Reboot
doas reboot
