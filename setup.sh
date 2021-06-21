#!/bin/bash

# Setup script for arch linux with my dotfiles

# Packages i use
sudo pacman --noconfirm -Syu git zsh xorg-server xorg-xinit mpd rxvt-unicode mpv man youtube-dl alsa-utils htop sxiv xclip neofetch npm clang pulseaudio pulseaudio-alsa dos2unix dosfstools ttf-liberation
sudo pacman --noconfirm -S firefox ncmpcpp acpilight zathura zathura-pdf-mupdf

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
git clone https://github.com:aleksav013/st
cd st
sudo make clean install
cd ..
git clone https://github.com/aleksav013/dwmblocks
cd dwm
sudo make clean install
cd ..
git clone https://github.com:aleksav013/dotfiles
cd dotfiles
cp -rf .* $HOME
rm -rf $HOME/.git
rm -rf $HOME/.bash*

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
git clone https://aur.archlinux/org/nerd-fonts-inconsolata
cd nerd-fonts-inconsolata
makepkg --noconfirm -si

# Setup LSP
sudo npm i -g bash-language-server intelephense vscode-html-languageserver-bin

# change locale and LANG
sudo -- sh -c 'echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen'
sudo locale-gen
sudo -- sh -c 'echo "LANG=en_US.UTF-8" > /etc/locale.conf'

# Reboot
sudo reboot
