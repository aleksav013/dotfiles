#!/bin/sh

install_yay() {
	cd
	mkdir -p git
	cd git
	sudo pacman -Syu --needed --noconfirm
	git clone https://aur.archlinux.org/yay-bin.git
	cd yay-bin
	makepkg -si --noconfirm
	cd
}

pacman_conf() {
	sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf
}

install_packages() {
	# Official repo packages
	sudo pacman -Syu --needed --noconfirm \
		alsa-utils \
		doas \
		firefox \
		git \
		htop \
		libxft \
		maim \
		man-db \
		man-pages \
		mpd \
		mpv \
		ncmpcpp \
		neovim \
		npm \
		openssh \
		pamixer \
		perl-file-mimeinfo \
		picom \
		pipewire \
		pipewire-pulse \
		sbctl \
		stow \
		ttf-jetbrains-mono-nerd \
		unclutter \
		wireplumber \
		xclip \
		xorg-server \
		xorg-util-macros \
		xorg-xinit \
		xwallpaper \
		zathura \
		zathura-pdf-mupdf \
		zsh

	# AUR packages
	yay --noremovemake --noconfirm -Syu \
		acpilight \
		fastfetch \
		lf-bin \
		nsxiv \
		yay-bin

	# conflict pipewire-jack & jack2
	yay --noremovemake -Syu pipewire-jack
}

doas_conf() {
	sudo -- sh -c 'printf "permit persist :wheel\n" > /etc/doas.conf'
	doas usermod -a -G video,disk,wheel "$(whoami)"
}

libxft_bgra() {
	cd
	mkdir -p git
	cd git
	git clone https://github.com/uditkarode/libxft-bgra
	cd libxft-bgra
	sh autogen.sh --sysconfdir=/etc --prefix=/usr --mandir=/usr/share/man
	doas make install
	cd
}

zsh_conf() {
	doas chsh -s "$(which zsh)" "$USER"
	mkdir -p ~/.cache/zsh
}

change_locale() {
	doas -- sh -c 'printf "en_US.UTF-8 UTF-8\nsr_RS@latin UTF-8\nsr_RS UTF-8" >> /etc/locale.gen'
	doas locale-gen
	doas -- sh -c 'printf "LANG=en_US.UTF-8" > /etc/locale.conf'
}

mygit() {
	cd
	mkdir -p mygit
	cd mygit

	git clone https://github.com/aleksav013/dwm
	cd dwm
	doas make clean install
	cd ..
	git clone https://github.com/aleksav013/dmenu
	cd dmenu
	doas make clean install
	cd ..
	git clone https://github.com/aleksav013/st
	cd st
	doas make clean install
	cd ..
	git clone https://github.com/aleksav013/dwmblocks
	cd dwmblocks
	doas make clean install
	cd ..
	git clone https://github.com/aleksav013/dotfiles
	cd dotfiles
	./sync.sh
	cd ..
	git clone https://github.com/aleksav013/nvim
	cd nvim
	./sync.sh
	cd ..

	cd
}

other_repos() {
	cd
	mkdir -p git
	cd git

	git clone https://github.com/ujjwal96/xwinwrap
	cd xwinwrap
	doas make
	doas make install
	make clean
	cd ..

	git clone https://github.com/LukeSmithxyz/mutt-wizard
	cd mutt-wizard
	doas make install
	cd ..

	cd
}

main() {
	set -eo
	cd

	printf "install_yay\n"
	install_yay
	printf "install_yay\n"

	printf "pacman_conf\n"
	pacman_conf
	printf "pacman_conf\n"

	printf "install_packages\n"
	install_packages
	printf "install_packages\n"

	printf "doas_conf\n"
	doas_conf
	printf "doas_conf\n"

	printf "libxft_bgra\n"
	libxft_bgra
	printf "libxft_bgra\n"

	printf "zsh_conf\n"
	zsh_conf
	printf "zsh_conf\n"

	printf "change_locale\n"
	change_locale
	printf "change_locale\n"

	printf "mygit\n"
	mygit
	printf "mygit\n"

	printf "other_repos\n"
	other_repos
	printf "other_repos\n"
}

main
