#!/bin/sh

### Setup script for Artix Linux with my dotfiles

## Packages i use


#Artix repos
sudo pacman --noconfirm -Syu git zsh xorg-server xorg-xinit neovim mpd mpv man alsa-utils htop xclip neofetch npm pulseaudio pulseaudio-alsa ttf-liberation librewolf

#Arch repos
sudo pacman --noconfirm -S acpilight ncmpcpp zathura zathura-pdf-mupdf stow sxiv xwallpaper xcompmgr pamixer ccls


#Change shell to zsh
sudo chsh -s "$(which zsh)" "$USER"

# My git repos
cd || exit
mkdir mygit
cd mygit || exit

git clone https://github.com/aleksav013/dwm
cd dwm || exit
sudo make clean install
cd ..
git clone https://github.com/aleksav013/dmenu
cd dmenu || exit
sudo make clean install
cd ..
git clone https://github.com/aleksav013/st
cd st || exit
sudo make clean install
cd ..
git clone https://github.com/aleksav013/dwmblocks
cd dwmblocks || exit
sudo make clean install
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
mkdir git
cd git || exit


# AUR
yay -S libxft-bgra-git nerd-fonts-inconsolata lf-bin

# Setup LSP
sudo npm i -g bash-language-server vscode-langservers-extracted

# change locale and LANG
sudo -- sh -c 'echo "en_US.UTF-8 UTF-8\nsr_RS@latin UTF-8\nsr_RS UTF-8" >> /etc/locale.gen'
sudo locale-gen
sudo -- sh -c 'echo "LANG=en_US.UTF-8" > /etc/locale.conf'

# Reboot
sudo reboot
