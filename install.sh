apt install xmonad cabal-install feh taffybar hsetroot xcompmgr numlockx libgtk-3-dev indicator-cpufreq suckless-tools -y
# haskell depend
apt install gobject-introspection libgirepository1.0-dev libdbusmenu-gtk3-dev -y
sudo apt-get install libgirepository1.0-dev libwebkit2gtk-4.0-dev libgtksourceview-3.0-dev -y

# 我想要一劳永逸地解决启动资源管理器就启动gnome整个桌面系统的问题
# 所以使用nemo
sudo apt install dconf-tools nemo -y
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.nemo.desktop show-desktop-icons false
gsettings set org.gnome.desktop.background show-desktop-icons true
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
# 恢复使用nautilus(原生资源管理器)使用一下命令
# xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
