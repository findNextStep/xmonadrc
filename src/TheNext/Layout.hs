module TheNext.Layout(
    layout
)where
import XMonad.Layout
import XMonad.Hooks.ManageDocks         (avoidStruts)
import XMonad.Layout.NoBorders          (noBorders,smartBorders)
import XMonad.Layout.MouseResizableTile


layout = smartBorders $ avoidStruts tiled  ||| smartBorders(avoidStruts  mirrorTiled) ||| noBorders Full
    where
        tiled =  mouseResizableTile
            { nmaster = myNmaster
            , masterFrac =  myMasterFrac
            , slaveFrac = mySlaveFrac
            , fracIncrement = myFracIncrement
            , draggerType = myDraggerType
            }
        mirrorTiled = mouseResizableTileMirrored
            { nmaster = myNmaster
            , masterFrac =  myMasterFrac
            , slaveFrac = mySlaveFrac
            , fracIncrement = myFracIncrement
            , draggerType = myDraggerType
            }
        myNmaster = 1
        myMasterFrac = 1/2
        mySlaveFrac = 1/2
        myFracIncrement = 2/100
        myDraggerType = FixedDragger 1 1