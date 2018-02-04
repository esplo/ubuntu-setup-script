#!/bin/bash

cat <<EOF | tee ~/.local/share/applications/ccminer.desktop
[Desktop Entry]
Type=Application
Name=CC Miner
GenericName=CC Miner
X-GNOME-FullName=CC Miner
Icon=${HOME}/miner/run.sh
Exec=gnome-terminal -- bash -c 'cd ${HOME}/miner; bash run.sh'
Terminal=True
Categories=Development;IDE;
EOF

chmod 600 ~/.local/share/applications/ccminer.desktop

