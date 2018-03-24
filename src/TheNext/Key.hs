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

altMask = mod1Mask 

keys:: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keys conf@XConfig {XMonad.modMask = modm} = M.fromList $

    -- 启动app
    -- 启动一个终端
    [ ((modm                , xK_Return     ), spawn APP.terminal)

    -- 启动启动器
    , ((modm                , xK_p          ), spawn APP.launcher)
    ]
    ++

    -- 关闭程序
    [ ((modm .|. shiftMask  , xK_c          ), kill)
    , ((altMask             , xK_F4         ), kill)

    -- 下一个布局算法
    , ((modm                , xK_space      ), sendMessage NextLayout)

    -- 重置布局算法 
    , ((modm .|. shiftMask  , xK_space      ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm                , xK_n          ), refresh)

    -- 锁定下一个窗口
    , ((modm                , xK_Tab        ), windows W.focusDown)

    -- 出于习惯
    , ((altMask             , xK_Tab        ), windows W.focusDown)

    -- 锁定下一个窗口
    , ((modm                , xK_j          ), windows W.focusDown)

    -- 锁定上一个窗口
    , ((modm                , xK_k          ), windows W.focusUp)

    -- 锁定主窗口
    , ((modm                , xK_m          ), windows W.focusMaster)

    -- 将当前窗口放入主区域
    , ((modm .|. shiftMask  , xK_Return     ), windows W.swapMaster)

    -- 转换到上一个位置
    , ((modm .|. shiftMask  , xK_j          ), windows W.swapDown)

    -- 转换到下一个位置
    , ((modm .|. shiftMask  , xK_k          ), windows W.swapUp)

    -- 缩小主窗口
    , ((modm                , xK_h          ), sendMessage Shrink)

    -- 放大主窗口
    , ((modm                , xK_l          ), sendMessage Expand)

    -- 使得窗口退出float模式
    , ((modm                , xK_t          ), withFocused $ windows . W.sink)

    -- super + , 
    , ((modm                , xK_comma      ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm                , xK_period     ), sendMessage (IncMasterN (-1)))

    -- 重启xmonad
    , ((modm                , xK_q          ), spawn "xmonad --recompile && xmonad --restart")

    -- 退出xmonad
    ,((modm .|. shiftMask   , xK_q          ),  io exitSuccess)
    ]
    ++
    
    -- | 音量控制
    -- | 音量增加
    [((modm               , xK_F5    ), spawn ("pactl set-sink-volume 0 -" ++ Param.volumeInterval ++ "%"))
    -- | 音量减少
    ,((modm               , xK_F6    ), spawn ("pactl set-sink-volume 0 +" ++ Param.volumeInterval ++ "%"))
    -- | 立即静音
    ,((modm               , xK_F3    ), spawn "pactl set-sink-volume 0 0")

    ]
    ++
    -- 工作区切换
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- 多屏幕控制
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

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