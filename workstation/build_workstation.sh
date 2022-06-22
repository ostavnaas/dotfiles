#!/usr/bin/env bash

set -eux


sudo apt-get update
sudo apt-get install keepassx vim git tmux zsh curl \
                     iputils-arping net-tools tcptraceroute \
                     python3-venv python3-pip jq cmake ethtool \
                     xclip sipcalc fonts-powerline iptables-persistent \
                     whois dnsutils -y




# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Vundle
# https://github.com/VundleVim/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

mkdir -p ~/github/ostavnaas
git clone git@github.com:ostavnaas/dotfiles.git ~/github/ostavnaas/dotfiles/
ln -fs ~/github/ostavnaas/dotfiles/.zshrc ~/.zshrc
ln -fs ~/github/ostavnaas/dotfiles/.vimrc ~/.vimrc
ln -fs ~/github/ostavnaas/dotfiles/.tmux.conf ~/.tmux.conf


# Gnome terminal
dconf load /org/gnome/terminal/legacy/profiles:/ < ~/github.com/ostavnaas/dotfiles/workstation/files/gnome-terminal


# Disable non-breaking space
dconf write /org/gnome/desktop/input-sources/xkb-options "['nbsp:none']"

# Pulseaudio defaults
# https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/DefaultDevice/
# List output device
echo "pactl list short sinks"
# List input device
echo "pactl list short sources"


echo "vim /etc/pulse/default.pa"
echo "set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo"
echo "set-default-source alsa_input.usb-046d_HD_Pro_Webcam_C920_F3E259AF-02.analog-stereo"


# Poweroff when laptop lid is closed
sudo sed -E 's/#HandleLidSwitch=(\w+)/HandleLidSwitch=poweroff/' -i /etc/systemd/logind.conf
sudo systemctl restart systemd-logind.service


sudo pip3 install httpcode
sudo chsh $(whoami) --shell=/bin/zsh
