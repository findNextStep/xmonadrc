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
focusFollowsMouse = True

clickJustFocuses :: Bool
clickJustFocuses = True

borderWidth :: Dimension
borderWidth = 1

defaultModMask :: KeyMask
defaultModMask = mod4Mask

normalBorderColor, focusedBorderColor :: String
normalBorderColor  = "gray" -- "#dddddd"
focusedBorderColor = "red"  -- "#ff0000" don't use hex, not <24 bit safe