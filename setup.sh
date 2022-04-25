#!/bin/bash

set -eux

NVIDIA_DRIVER_VER=510


# nvidia
sudo apt-get -y --purge remove nvidia-*
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt -y update
sudo apt -y install nvidia-driver-${NVIDIA_DRIVER_VER}


# apps
sudo apt-get -y update
INSTALL_APPS=(vim git steam)
for soft in ${INSTALL_APPS[@]}
do
  sudo apt-get -y install ${soft}
done


# VS Code
sudo snap install --classic code


# docker
sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg    
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -y update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# already exists
# sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl enable containerd.service


# chrome
sudo apt-get -y install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp/chrome
sudo dpkg -i /tmp/chrome/*.deb


# dropbox
sudo apt install -y nautilus-dropbox


# kinto
/bin/bash -c "$(wget -qO- https://raw.githubusercontent.com/rbreaves/kinto/HEAD/install/linux.sh || curl -fsSL https://raw.githubusercontent.com/rbreaves/kinto/HEAD/install/linux.sh)"
mkdir -p ~/.config/kinto/
cp ./kinto.py ~/.config/kinto/kinto.py


# fish
sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt -y update
sudo apt -y install fish
command -v fish | sudo tee -a /etc/shells
sudo chsh -s $(command -v fish)

fish -c 'curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher'
sudo apt -y install fzf
fish -c 'fisher install jethrokuan/fzf'
fish -c 'fisher install jethrokuan/z'

# nvm
fish -c 'fisher install jorgebucaran/nvm.fish@2.1.0'
fish -c 'nvm install latest'
fish -c 'nvm use latest'


# typing
sudo apt -y install fcitx5-mozc
im-config -n fcitx5


# aws-vault
sudo curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/latest/download/aws-vault-linux-$(dpkg --print-architecture)
sudo chmod 755 /usr/local/bin/aws-vault


# Lutris
sudo add-apt-repository -y ppa:lutris-team/lutris
sudo apt -y update
sudo apt -y install lutris xdelta3 xterm


# tilix
sudo apt -y install tilix
# TODO: settings - global options


# shortcut for tilix
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"

export KEYNAME=custom0
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${KEYNAME}/ name 'Open Tilix'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${KEYNAME}/ binding '<Ctrl>bracketleft'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${KEYNAME}/ command 'tilix --quake'

export KEYNAME=custom1
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${KEYNAME}/ name 'Open Tilix'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${KEYNAME}/ binding '<Super>bracketleft'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${KEYNAME}/ command 'tilix --quake'


# flatpak
sudo apt -y install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


# discord
flatpak install flathub com.discordapp.Discord


# sound - Pipewire
# https://zenn.dev/moru3_48/articles/e50c4ef9b0a5c8
sudo add-apt-repository -y ppa:pipewire-debian/pipewire-upstream
sudo apt -y update
sudo apt -y install pipewire
sudo apt -y install libspa-0.2-bluetooth
systemctl --user --now disable  pulseaudio.{socket,service}
systemctl --user mask pulseaudio
systemctl --user --now enable pipewire{,-pulse}.{socket,service}


# sound - EasyEffects
# https://gist.github.com/buzztaiki/808f67d3963c3dad19c54a01b12fe0a1
flatpak install -y flathub com.github.wwmm.easyeffects
# TODO: config


# grub timeout
sed -i /etc/default/grub -e 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=1/g'


