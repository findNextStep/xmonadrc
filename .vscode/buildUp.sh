#!/bin/sh
cabal install && 
echo "-- cabal buil up" && 
xmonad --recompile && 
echo "-- set up over" || echo "-- fail"