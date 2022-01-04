stow --no-folding --ignore="laptop|setup.sh" -t ~ .
doas stow --no-folding --ignore=".rules" -t /etc/X11/xorg.conf.d laptop
doas stow --no-folding --ignore=".conf" -t /etc/udev/rules.d laptop
