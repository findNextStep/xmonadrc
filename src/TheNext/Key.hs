module TheNext.Key(
    mouseBindings,
    keys,
    defaultModMask
)where



import XMonad.Core                  as XMonad hiding    (keys,mouseBindings)
import qualified XMonad.Core        as XMonad           (workspaces,layoutHook,modMask)
import Data.Bits                                        ((.|.),(.&.))
import System.Exit                                      (exitSuccess)
import XMonad.Hooks.ManageDocks                         (ToggleStruts(..))
import XMonad.Actions.WindowMenu                        (windowMenu)
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import qualified XMonad.Operations  as OP
import qualified XMonad.StackSet    as W
import qualified Data.Map           as M
import qualified TheNext.DefalutApp as APP
import qualified TheNext.Param      as Param
import TheNext.System.Voice         as Voice
import XMonad.Layout
import Graphics.X11.Xlib
import XMonad.Layout.MouseResizableTile


-- | 可以通过xmodmap确定按键绑定
leftAltMask = mod1Mask
rightAltMask = mod3Mask
superMask = mod4Mask
ctrlMask = controlMask



-- | 默认关键键位，设置为super键和右alt
defaultModMask :: KeyMask
defaultModMask =  rightAltMask

switchTouchPad :: X()
switchTouchPad = spawn "id=$(xinput --list | grep Touch | awk -F\"=\" '{print $2}' | awk '{print $1}');xinput --list-props $id| grep Enable | awk '{print $4}' | grep  0 && xinput enable $id|| xinput disable $id"

keys:: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keys conf@XConfig {XMonad.modMask = modm} = M.fromList $

    -- 启动app
    -- 启动一个终端
    [ ((superMask           , xK_Return     ), spawn APP.terminal)

    -- 启动启动器
    , ((superMask           , xK_p          ), spawn APP.launcher)
    
    -- 启动gui时钟
    ,((superMask .|. ctrlMask,xK_t          ), spawn APP.myClock)

    -- 启动资源管理器
    , ((superMask           , xK_f          ), spawn APP.explorer)

    -- 启动浏览器
    , ((superMask           , xK_d          ), spawn APP.webBrowser)

    -- 锁定屏幕
    , ((superMask           , xK_l          ), spawn APP.screenLock)

    -- 屏幕截图
    , ((ctrlMask .|. leftAltMask,xK_a       ), spawn APP.screenShutter)
    ]

    ++ 
    -- 控制触摸板启动或者关闭
    [ ((superMask           , xK_F1         ), switchTouchPad)
    ]

    ++

    -- 关闭程序
    [ ((modm                , xK_c          ), OP.kill)
    , ((leftAltMask         , xK_F4         ), OP.kill)

    -- 下一个布局算法
    , ((modm                , xK_space      ), OP.sendMessage NextLayout)

    -- 重置布局算法
    , ((modm .|. shiftMask  , xK_space      ), OP.setLayout $ XMonad.layoutHook conf)

    -- 重新设置屏幕
    , ((modm                , xK_n          ), OP.sendMessage ToggleStruts)

    -- 锁定下一个窗口
    , ((modm                , xK_Tab        ), OP.windows W.focusDown)

    -- 锁定下一个窗口
    , ((modm                , xK_j          ), OP.windows W.focusDown)

    , ((leftAltMask         , xK_Tab        ), OP.windows W.focusDown)

    -- 锁定上一个窗口
    , ((modm                , xK_k          ), OP.windows W.focusUp)

    -- 锁定主窗口
    , ((modm                , xK_m          ), OP.windows W.focusMaster)
    , ((modm                , xK_o          ), windowMenu)
    -- 将当前窗口放入主区域
    , ((modm .|. shiftMask  , xK_Return     ), OP.windows W.swapMaster)

    -- 转换到上一个位置
    , ((modm .|. shiftMask  , xK_j          ), OP.windows W.swapDown)

    -- 转换到下一个位置
    , ((modm .|. shiftMask  , xK_k          ), OP.windows W.swapUp)

    -- 缩小主窗口
    , ((modm                , xK_h          ), OP.sendMessage Shrink)
    -- 窗口垂直缩小
    , ((modm                , xK_u          ), OP.sendMessage ShrinkSlave)
    -- 窗口垂直放大
    , ((modm                , xK_i          ), OP.sendMessage ExpandSlave)
    -- 放大主窗口
    , ((modm                , xK_l          ), OP.sendMessage Expand)

    -- 使得窗口退出float模式
    , ((modm                , xK_t          ), OP.withFocused $ OP.windows . W.sink)

    -- super + ,  增加主区域的窗口数量
    , ((modm                , xK_comma      ), OP.sendMessage (IncMasterN 1))

    -- super + . 减少主区域的窗口数量
    , ((modm                , xK_period     ), OP.sendMessage (IncMasterN (-1)))

    -- 重启xmonad
    , ((modm                , xK_q          ), spawn "pkill taffybar;~/.cabal/bin/xmonad --restart")

    -- 退出xmonad
    ,((modm .|. shiftMask   , xK_q          ), confirmPrompt defaultXPConfig "quit" $ io exitSuccess)
    ]
    ++

    -- | 音量控制
    -- | 音量增加
    [((superMask          , xK_F5    ), Voice.volumeIncrease (-Param.volumeInterval))
    -- | 音量减少
    ,((superMask          , xK_F6    ), Voice.volumeDecrease Param.volumeInterval)
    -- | 立即静音
    ,((superMask          , xK_F3    ), Voice.mute)

    ]
    ++
    -- 工作区切换
    [((m .|. superMask, k), OP.windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf)([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- 多屏幕控制
    [((m .|. superMask, key), OP.screenWorkspace sc >>= flip whenJust (OP.windows . f))
        | (key, sc) <- zip [xK_q, xK_w, xK_e] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

mouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
mouseBindings XConfig {XMonad.modMask = modMask} = M.fromList
    -- mod-button1 %! Set the window to floating mode and move by dragging
    [ ((superMask, button1), \w -> OP.focus w >> OP.mouseMoveWindow w
                                            >> OP.windows W.shiftMaster)
    -- mod-button2 %! Raise the window to the top of the stack
    , ((superMask, button2), OP.windows . (W.shiftMaster .) . W.focusWindow)
    -- mod-button3 %! Set the window to floating mode and resize by dragging
    , ((superMask, button3), \w -> OP.focus w >> OP.mouseResizeWindow w
                                            >> OP.windows W.shiftMaster)
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
