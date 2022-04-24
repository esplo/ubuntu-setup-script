#!/bin/bash

set -eux

NVIDIA_DRIVER_VER=510


# nvidia
sudo apt-get -y --purge remove nvidia-*
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt -y update
sudo apt -y install nvidia-driver-${NVIDIA_DRIVER_VER}


# apps
sudo apt-get -y update
INSTALL_APPS=(vim git steam)
for soft in ${INSTALL_APPS[@]}
do
  sudo apt-get -y install ${soft}
done


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

sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl enable containerd.service


# chrome
sudo apt-get -y install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp/chrome.deb
sudo dpkg -i /tmp/chrome.deb


# dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd


# kinto
/bin/bash -c "$(wget -qO- https://raw.githubusercontent.com/rbreaves/kinto/HEAD/install/linux.sh || curl -fsSL https://raw.githubusercontent.com/rbreaves/kinto/HEAD/install/linux.sh)"
cp ./kinto.py ~/.config/kinto/kinto.py


# fish
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt -y update
sudo apt -y install fish
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install jethrokuan/fzf
fisher install jethrokuan/z

# nvm
fisher install jorgebucaran/nvm.fish@2.1.0
nvm install latest
nvm use latest


# typing
sudo apt -y install fcitx5-mozc
im-config -n fcitx5


# aws-vault
sudo curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/latest/download/aws-vault-linux-$(dpkg --print-architecture)
sudo chmod 755 /usr/local/bin/aws-vault


# Lutris
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt -y update
sudo apt -y install lutris


# tilix
sudo apt -y install tilix 


# shortcut for tilix
KEYNAME=custom0
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${KEYNAME}/ name 'Open Tilix'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${KEYNAME}/ binding '<Ctrl>['
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${KEYNAME}/ command 'tilix --quake'

KEYNAME=custom1
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${KEYNAME}/ name 'Open Tilix'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${KEYNAME}/ binding '<Super>['
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${KEYNAME}/ command 'tilix --quake'


# flatpak
sudo apt -y install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


# discord
flatpak install flathub com.discordapp.Discord


# sound - Pipewire
# https://zenn.dev/moru3_48/articles/e50c4ef9b0a5c8
sudo add-apt-repository ppa:pipewire-debian/pipewire-upstream
sudo apt -y update
sudo apt -y pipewire
sudo apt -y install libspa-0.2-bluetooth
systemctl --user --now disable  pulseaudio.{socket,service}
systemctl --user mask pulseaudio
systemctl --user --now enable pipewire{,-pulse}.{socket,service}


# sound - EasyEffects
# https://gist.github.com/buzztaiki/808f67d3963c3dad19c54a01b12fe0a1
flatpak install flathub com.github.wwmm.easyeffects

cat << EOF > ~/.config/autostart/easyeffects-service.desktop
[Desktop Entry]
Name=EasyEffects
Comment=EasyEffects Service
Exec=easyeffects --gapplication-service
Icon=easyeffects
StartupNotify=false
Terminal=false
Type=Application
EOF

gsettings com.github.wwmm.easyeffects process-all-inputs true
gsettings com.github.wwmm.easyeffects process-all-outputs true

cat << EOF > ~/.config/easyeffects/input/noise-reduction.json
{
    "input": {
        "blocklist": [],
        "plugins_order": [
            "rnnoise"
        ],
        "rnnoise": {
            "input-gain": 0.0,
            "model-path": "",
            "output-gain": 0.0
        }
    }
}
EOF
flatpak run com.github.wwmm.easyeffects -l noise-reduction

### TODO: output plugin
