#!/bin/sh
cabal install && 
echo "-- cabal buil up" && 
xmonad --recompile && 
echo "-- xmonad compile finsh" &&
cp ~/.xmonad/resources/taffybar.rc ~/.config/taffybar/ && 
cp ~/.xmonad/resources/taffybar.css ~/.config/taffybar/ &&
echo "-- set up over" || echo "-- fail"