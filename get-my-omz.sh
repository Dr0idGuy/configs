#!/bin/bash
set -e
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mkdir -p ~/code
pushd ~/code
git clone https://github.com/robobenklein/configs.git
popd
mkdir -p ~/Downloads
pushd ~/Downloads
curl -fsSL https://github.com/powerline/fonts/raw/master/UbuntuMono/Ubuntu%20Mono%20derivative%20Powerline.ttf > Ubuntu\ Mono\ derivative\ Powerline.ttf
#gnome-font-viewer Ubuntu\ Mono\ derivative\ Powerline.ttf
popd
mv ~/.zshrc ~/.zshrc.old
ln -s ~/code/configs/zsh/.zshrc ~/.zshrc
echo "Linked new zshrc"

