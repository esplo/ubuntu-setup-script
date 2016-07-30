#!/bin/bash

set -eux

# software install
sudo apt-get -y update
INSTALL_SOFTS=(vim git steam openjdk-8-jdk icedtea-netx nkf)
for soft in ${INSTALL_SOFTS[@]}
do
  sudo apt-get -y install ${soft}
done

# google japanese input
sudo apt-get -y install $(check-language-support)

# install chrome
sudo apt-get -y install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb

# install CLion
wget https://download.jetbrains.com/cpp/CLion-2016.2.tar.gz
tar zxvf CLion*.tar.gz
mkdir -p ~/ide
mv clion-*/* ~/ide/clion/
rm -r clion-*

# install dropbox
wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb -O dropbox.deb
sudo dpkg -i dropbox.deb
sudo apt-get -f -y install
sudo dpkg -i dropbox.deb
rm dropbox.deb

# settings
dconf reset /org/gnome/settings-daemon/plugins/keyboard/active
dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"

# for steam
echo "LD_PRELOAD='/usr/$LIB/libstdc++.so.6' DISPLAY=:0 steam" > run_steam.sh
chmod 755 run_steam.sh

# folder name
LANG=C xdg-user-dirs-gtk-update

# thunderbird profile
mkdir -p ~/.thunderbird
cp -r ./backup_thunderbird/* ~/.thunderbird/


# mozc
#  Henkan/Muhenkan 

# hybernate menu
cat << EOT | sudo tee -a /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
[Re-enable hibernate by default in upower]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes

[Re-enable hibernate by default in logind]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate;org.freedesktop.login1.handle-hibernate-key;org.freedesktop.login1;org.freedesktop.login1.hibernate-multiple-sessions;org.freedesktop.login1.hibernate-ignore-inhibit
ResultActive=yes
EOT

# cleanup
sudo apt-get -y autoremove


