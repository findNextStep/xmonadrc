module TheNext.Bar.Unit (
    addConfig,
    title,
    workspace,
    unitBase
) where

import qualified Graphics.UI.Gtk as Gtk
import Graphics.UI.Gtk.Abstract.Container           (containerRemove,containerAdd)
import System.Taffybar.Widgets.PollingLabel         (pollingLabelNew)
import Text.Printf                                  (printf)
import Graphics.UI.Gtk.Misc.TrayManager
import System.Taffybar.WindowSwitcher
import System.Taffybar.WorkspaceHUD
import System.Taffybar.WorkspaceSwitcher
import System.Taffybar.Pager
import Control.Concurrent
import Control.Monad ( forever )

data UnitConfig = UnitConfig{ fontColor :: IO (Int,Int,Int)
                            , fontSize :: IO Int
                            , backgroundColor ::IO (Int,Int,Int)
                            , font :: IO String
                            }

-- | 一个基于字符串的基本组件
unitBase :: IO String -> IO Gtk.Widget
unitBase content = do
    l <- pollingLabelNew "waitForInit" 1 content
    Gtk.widgetShowAll l
    return $ Gtk.toWidget l

-- | 显示当前工作窗口名称
title =  do
    pagers <- pagerNew defaultPagerConfig
    windowSwitcherNew pagers


-- | 显示工作区
workspace =  do
    pagers <- pagerNew defaultPagerConfig
        { workspaceBorder           = False
        }
    wspaceSwitcherNew pagers

-- | 为纯文本组件添加配置
addConfig :: IO String -> (IO String -> IO UnitConfig) -> IO String
addConfig content configFun = do
    config <- configFun content
    input <- content
    myfont <- font config
    myfontSize <- fontSize config
    (fr,fb,fg) <- fontColor config
    return ("<span font='" ++
        myfont ++ " "   ++
        printf "%d" myfontSize ++ "' fgcolor='"++
        makeColor (fr,fg,fb)++ "'>"  ++ input ++ "%</span>")

-- | 将颜色数值转变为颜色描述字符串
makeColor :: (Int,Int,Int) -> String
makeColor (r,g,b) = printf "#%02x%02x%02x" r b g

-- | 默认组件设置
defaultConfig :: IO String -> IO UnitConfig
defaultConfig string = return UnitConfig{
    fontColor = return (0,0,0)
    , fontSize = return 9
    , backgroundColor = return (0,0,0)
    , font = return "ubuntu Mono 10"
}