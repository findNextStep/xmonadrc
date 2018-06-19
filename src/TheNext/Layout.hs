module TheNext.Layout(
    layout
)where
import XMonad.Layout
import XMonad.Hooks.ManageDocks(avoidStruts)

-- layout = avoidStruts(tiled ||| Mirror tiled ||| Full )
layout = avoidStruts tiled ||| avoidStruts(Mirror tiled) ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
