#!/bin/bash

set -eux

sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt install oracle-java9-installer
sudo apt install oracle-java9-set-default


# Android Studio
sudo apt install -y gcc-multilib g++-multilib libc6-dev-i386 qemu-kvm mesa-utils
URL=https://dl.google.com/dl/android/studio/ide-zips/3.0.0.18
wget -q ${URL}/android-studio-ide-171.4408382-linux.zip
unzip -q android-studio-ide-171.4408382-linux.zip -d ~/bin/
rm -f android-studio-ide-171.4408382-linux.zip

mkdir -p ~/.local/share/applications
cat <<EOF | tee ~/.local/share/applications/android-studio.desktop
[Desktop Entry]
Type=Application
Name=Android Studio
GenericName=Android Studio
X-GNOME-FullName=Android Studio
Icon=${HOME}/bin/android-studio/bin/studio.png
Exec=${HOME}/bin/android-studio/bin/studio.sh
Terminal=false
Categories=Development;IDE;
EOF
chmod 600 ~/.local/share/applications/android-studio.desktop

# git

sudo apt install -y meld
cat <<EOF | sudo tee ~/.gitconfig
[diff]
  tool = meld
[difftool "meld"]
  cmd = meld $LOCAL $REMOTE
[merge]
  tool = meld
[mergetool "meld"]
  cmd = meld $LOCAL $BASE $REMOTE --auto-merge
EOF

