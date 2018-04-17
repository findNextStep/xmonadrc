#!/bin/sh
cabal install && 
echo "-- cabal buil up" && 
xmonad --recompile && 
echo "-- xmonad compile finsh" &&
cp ~/.xmonad/taffybar.rc ~/.config/taffybar/
echo "-- set up over" || echo "-- fail"

