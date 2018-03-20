module TheNext.Hook(
    manageHook,
    clientMask,
    rootMask
)where

import XMonad.ManageHook
import XMonad.Core(ManageHook)
import Data.Bits ((.|.))
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras

manageHook :: ManageHook
manageHook = composeAll
                [ className =? "MPlayer"        --> doFloat
                , className =? "mplayer2"       --> doFloat
                , className =? "Gimp"           --> doFloat
                , className =? "xclock"         --> doFloat 
                , resource  =? "desktop_window" --> doIgnore
                , resource  =? "kdesktop"       --> doIgnore ]

clientMask :: EventMask
clientMask = structureNotifyMask .|. enterWindowMask .|. propertyChangeMask

-- | The root events that xmonad is interested in
rootMask :: EventMask
rootMask =  substructureRedirectMask .|. substructureNotifyMask
        .|. enterWindowMask .|. leaveWindowMask .|. structureNotifyMask
        .|. buttonPressMask