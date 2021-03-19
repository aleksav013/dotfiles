#!/bin/bash

# Setup script for arch linux with my dotfiles

# Packages i use
sudo pacman --noconfirm -Syu git zsh xorg-server xorg-xinit mpd ncmpcpp firefox zathura zathura-pdf-mupdf rxvt-unicode ttf-liberation mpv man youtube-dl alsa-utils htop sxiv xclip neofetch npm clang

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
git clone https://github.com/aleksav013/dotfiles
cd dotfiles

# Copy dotfiles
cp -rf .* $HOME
rm -rf $HOME/.git
rm -rf $HOME/.bash*

# Repos i use
cd
mkdir git
cd git

git clone https://git.suckless.org/st
cd st
sudo make clean install
cd ..
git clone https://git.suckless.org/dmenu
cd dmenu
sudo make clean install
cd ..
git clone https://github.com/simmel/urxvt-resize-font
mkdir -p ~/.urxvt/ext/
cp urxvt-resize-font/resize-font ~/.urxvt/ext/
git clone https://aur.archlinux.org/neovim-git
cd neovim-git
makepkg --noconfirm -si
cd ..
git clone https://aur.archlinux.org/nerd-fonts-inconsolata
cd nerd-fonts-inconsolata
makepkg --noconfirm -si
cd ..
git clone https://aur.archlinux.org/lf-bin
cd lf-bin
makepkg --noconfirm -si

# Setup LSP
sudo npm i -g bash-language-server intelephense vscode-html-languageserver-bin

# change locale and LANG
sudo -- sh -c 'echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen'
sudo locale-gen
sudo -- sh -c 'echo "LANG=en_US.UTF-8" > /etc/locale.conf'

# Reboot
reboot
