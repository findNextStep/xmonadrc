#!/bin/sh
cabal install && 
echo "-- cabal buil up" && 
xmonad --recompile && 
echo "-- xmonad compile finsh" &&
echo "-- set up over" || echo "-- fail"

