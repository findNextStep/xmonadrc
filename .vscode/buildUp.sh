#!/bin/sh
cabal install && 
echo "-- cabal buil up" && 
xmonad --recompile && 
echo "-- xmonad compile finsh" &&
if [ ! -d ./.config/taffybar ];then 
mkdir ~/.config/taffybar -p
fi&&
cp ~/.xmonad/taffybar.hs ~/.config/taffybar/ &&
echo "-- set up over" || echo "-- fail"

