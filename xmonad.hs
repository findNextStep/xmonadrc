import XMonad
import XMonad.Util.Run(spawnPipe)
import TheNext

main = do
    -- | 设置窗口透明和切换特效
    xmproc <- spawnPipe "xcompmgr -Ss -n -Cc -fF -I-10 -O-10 -D1 -t-3 -l-4 -r4&"
    xmonad defaults
defaults = XConfig
    { XMonad.borderWidth        = TheNext.borderWidth
    , XMonad.workspaces         = TheNext.workspaces
    , XMonad.layoutHook         = TheNext.layout
    , XMonad.terminal           = TheNext.terminal
    , XMonad.normalBorderColor  = TheNext.normalBorderColor
    , XMonad.focusedBorderColor = TheNext.focusedBorderColor
    , XMonad.modMask            = TheNext.defaultModMask
    , XMonad.keys               = TheNext.keys
    , XMonad.logHook            = return ()
    , XMonad.startupHook        = return ()
    , XMonad.mouseBindings      = TheNext.mouseBindings
    , XMonad.manageHook         = TheNext.manageHook
    , XMonad.handleEventHook    = mempty -- TheNext.handleEventHook
    , XMonad.focusFollowsMouse  = TheNext.focusFollowsMouse
    , XMonad.clickJustFocuses   = TheNext.clickJustFocuses
    , XMonad.clientMask         = TheNext.clientMask
    , XMonad.rootMask           = TheNext.rootMask
    , XMonad.handleExtraArgs = \ xs theConf -> case xs of
            [] -> return theConf
            _ -> fail ("unrecognized flags:" ++ show xs)
    }