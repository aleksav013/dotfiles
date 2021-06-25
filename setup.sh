#!/bin/bash

### Setup script for Artix Linux with my dotfiles

## Packages i use


#Artix repos
sudo pacman --noconfirm -Syu git zsh xorg-server xorg-xinit mpd rxvt-unicode mpv man youtube-dl alsa-utils htop xclip neofetch npm clang pulseaudio pulseaudio-alsa dos2unix dosfstools ttf-liberation firefox-esr ranger

#Arch repos
sudo pacman --noconfirm -S acpilight ncmpcpp zathura zathura-pdf-mupdf stow sxiv xwallpaper xcompmgr ttf-joypixels


#Change shell to zsh
sudo chsh -s $(which zsh) $USER

# My git repos
cd
mkdir mygit
cd mygit

git clone https://github.com/aleksav013/dwm
cd dwm
sudo make clean install
cd ..
git clone https://github.com/aleksav013/st
cd st
sudo make clean install
cd ..
git clone https://github.com/aleksav013/dwmblocks
cd dwmblocks
sudo make clean install
cd ..
git clone https://github.com/aleksav013/dotfiles
cd dotfiles
stow --no-folding --ignore="laptop|setup.sh" -t ~ .
sudo stow --no-folding --ignore=backlight.rules -t /etc/X11/xorg.conf.d/ laptop
sudo stow --no-folding --ignore=30-touchpad.conf -t /etc/udev/rules.d laptop

# Repos i use
cd
mkdir git
cd git

git clone https://git.suckless.org/dmenu
cd dmenu
sudo make clean install
cd ..
git clone https://aur.archlinux.org/neovim-nightly-bin
cd neovim-nightly-bin
makepkg --noconfirm -si
cd ..
git clone https://aur.archlinux.org/libxft-bgra
makepkg --noconfirm -si
cd ..
git clone https://aur.archlinux.org/nerd-fonts-inconsolata
cd nerd-fonts-inconsolata
makepkg --noconfirm -si

# Setup LSP
sudo npm i -g bash-language-server intelephense vscode-langservers-extracted

# change locale and LANG
sudo -- sh -c 'echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen'
sudo locale-gen
sudo -- sh -c 'echo "LANG=en_US.UTF-8" > /etc/locale.conf'

# Reboot
sudo reboot
