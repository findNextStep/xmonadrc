module TheNext.Key(
    mouseBindings,
    keys 
)where

import XMonad.Core as XMonad hiding
    (workspaces,manageHook,keys,logHook,startupHook,borderWidth,mouseBindings
    ,layoutHook,terminal,normalBorderColor,focusedBorderColor,focusFollowsMouse
    ,handleEventHook,clickJustFocuses,rootMask,clientMask)
import qualified XMonad.Core as XMonad
    (workspaces,manageHook,keys,logHook,startupHook,borderWidth,mouseBindings
    ,layoutHook,modMask,terminal,normalBorderColor,focusedBorderColor,focusFollowsMouse
    ,handleEventHook,clickJustFocuses,rootMask,clientMask)

import XMonad.Layout
import XMonad.Operations
import qualified XMonad.StackSet as W
import Data.Bits ((.|.))
import qualified Data.Map as M
import System.Exit(exitSuccess)
import Graphics.X11.Xlib
import qualified TheNext.DefalutApp as APP
import qualified TheNext.Param as Param

keys:: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keys conf@XConfig {XMonad.modMask = modm} = M.fromList $

    -- launch a terminal
    [ ((modm ,              xK_Return), spawn APP.terminal)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn APP.launcher)

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- 出于习惯
    , ((mod1Mask,            xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    -- , ((modm              , xK_comma ), sendMessag  e (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    ,((modm .|. shiftMask , xK_q     ),  io exitSuccess)
    -- | 音量控制

    -- | 音量增加
    ,((modm               , xK_F5    ), spawn ("pactl set-sink-volume 0 -" ++ Param.volumeInterval ++ "%"))
    -- | 音量减少
    ,((modm               , xK_F6    ), spawn ("pactl set-sink-volume 0 +" ++ Param.volumeInterval ++ "%"))
    -- | 立即静音
    ,((modm               , xK_F3    ), spawn "pactl set-sink-volume 0 0f")

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
        -- where
        --     helpCommand :: X ()
        --     helpCommand = spawn ("echo | xmessage -file -")  -- %! Run xmessage with a summary of the default keybindings (useful for beginners)

mouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
mouseBindings XConfig {XMonad.modMask = modMask} = M.fromList
    -- mod-button1 %! Set the window to floating mode and move by dragging
    [ ((modMask, button1), \w -> focus w >> mouseMoveWindow w
                                            >> windows W.shiftMaster)
    -- mod-button2 %! Raise the window to the top of the stack
    , ((modMask, button2), windows . (W.shiftMaster .) . W.focusWindow)
    -- mod-button3 %! Set the window to floating mode and resize by dragging
    , ((modMask, button3), \w -> focus w >> mouseResizeWindow w
                                            >> windows W.shiftMaster)
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]