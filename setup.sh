#!/bin/sh

## setup script for artix linux with my dotfiles

# artix repos
sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf || exit
printf '\n[universe]\nServer = https://universe.artixlinux.org/$arch' | sudo tee -a /etc/pacman.conf > /dev/null || exit
sudo pacman --noconfirm -Syu \
acpilight alsa-utils archlinux-keyring archlinux-mirrorlist chrony-s6 doas \
git htop libxft maim man-db man-pages mpd mpv neofetch neovim npm openssh \
pulseaudio pulseaudio-alsa xclip xorg-server xorg-xinit xwallpaper zsh || exit

# doas.conf
sudo -- sh -c 'printf "permit persist :wheel\n" > /etc/doas.conf' || exit
doas pacman --noconfirm -Rns sudo || exit
doas usermod -a -G video "$(whoami)" || exit

# arch repos
printf '\n\n[extra]\nInclude = /etc/pacman.d/mirrorlist-arch\n\n[community]\nInclude = /etc/pacman.d/mirrorlist-arch' | doas tee -a /etc/pacman.conf > /dev/null
doas pacman --noconfirm -Syu \
ccls librewolf ncmpcpp pamixer perl-file-mimeinfo stow sxiv unclutter xcompmgr \
yay zathura zathura-pdf-mupdf

# change shell to zsh
doas chsh -s "$(which zsh)" "$USER"
mkdir -p ~/.cache/zsh

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
yay --noremovemake --nocleanafter -S \
lf-bin nerd-fonts-jetbrains-mono

# Reboot
doas reboot
