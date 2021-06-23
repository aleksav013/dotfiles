#!/bin/bash

# Setup script for arch linux with my dotfiles

# Packages i use
sudo pacman --noconfirm -Syu git zsh xorg-server xorg-xinit mpd rxvt-unicode mpv man youtube-dl alsa-utils htop xclip neofetch npm clang pulseaudio dos2unix dosfstools ttf-liberation stow firefox-esr
sudo pacman --noconfirm -S acpilight ncmpcpp zathura zathura-pdf-mupdf pulseaudio-alsa sxiv

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
stow --no-folding -t ~/.config .config
stow --no-folding -t ~/.local .local
stow -t ~ .gitconfig
stow -t ~ .xprofile
stow -t ~ .zprofile

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
