module TheNext.Layout(
    layout
)where
import XMonad.Layout
import XMonad.Hooks.ManageDocks         (avoidStruts)
import XMonad.Layout.NoBorders          (noBorders,smartBorders)
import XMonad.Layout.MouseResizableTile

layout = smartBorders $ avoidStruts tiled  ||| smartBorders(avoidStruts(Mirror tiled)) ||| noBorders Full
    where
        tiled =  mouseResizableTile
            { nmaster = 1
            , masterFrac = 1/2 
            , slaveFrac = 1/2
            , fracIncrement = 3/100
            , draggerType = FixedDragger 1 1
            }
