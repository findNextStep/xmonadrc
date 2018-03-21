module TheNext.Param(
    workspaces,
    focusFollowsMouse,
    clickJustFocuses,
    borderWidth,
    defaultModMask,
    normalBorderColor, 
    focusedBorderColor
)where

import XMonad.Core(WorkspaceId)
import Graphics.X11.Xlib.Types (Dimension)
import Graphics.X11.Types

workspaces :: [WorkspaceId]
workspaces = map show [1 .. 9 :: Int]

focusFollowsMouse :: Bool
focusFollowsMouse = False

clickJustFocuses :: Bool
clickJustFocuses = True

borderWidth :: Dimension
borderWidth = 3

defaultModMask :: KeyMask
defaultModMask = mod4Mask

normalBorderColor, focusedBorderColor :: String
normalBorderColor  = "#000000"
focusedBorderColor = "#325A8E" -- don't use hex, not <24 bit safe