#!/bin/sh
# 安装自定义库
cabal install && 
echo "-- cabal buil up" && 
# 如果不是xmoand配置文件夹，复制文件
if [ $(pwd) != ~/.xmonad ];then 
cp ./xmonad.hs ~/.xmonad && 
cp ./xmonad-session-rc ~/.xmonad
fi &&
echo "-- xmonad copy successed" && 
# 检查编译是否存在问题
xmonad --recompile && 
echo "-- xmonad compile finsh" &&
# 复制taffybar文件
cp ~/.xmonad/resources/taffybar.rc ~/.config/taffybar/ && 
cp ~/.xmonad/resources/taffybar.css ~/.config/taffybar/ &&
echo "-- set up over" || echo "-- fail"