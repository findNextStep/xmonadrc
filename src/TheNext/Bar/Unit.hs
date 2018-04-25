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
unitBase :: IO String -> IO Gtk.Widget
unitBase content = do
    l <- pollingLabelNew "waitForInit" 1 content
    Gtk.widgetShowAll l
    return $ Gtk.toWidget l

reFlashUnit :: IO Gtk.Widget -> IO Gtk.Widget
reFlashUnit get = do
    vbox <- Gtk.vBoxNew False 0
    wi <- get
    containerAdd vbox wi
    _ <- forkIO $ forever $ do
        containerRemove vbox wi
        wi <- get
        containerAdd vbox wi
        -- Gtk.widgetShowAll vbox
        threadDelay $ floor (1 * 1000000)
    Gtk.widgetShowAll vbox
    return $ Gtk.toWidget vbox

workspace = workspaceIn

title =  do
    pagers <- pagerNew defaultPagerConfig
    windowSwitcherNew pagers

workspaceIn =  do
    pagers <- pagerNew defaultPagerConfig
        { workspaceBorder           = False
        -- , useImages                 = True
        -- , fillEmptyImages           = True
        }
    wspaceSwitcherNew pagers

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

makeColor :: (Int,Int,Int) -> String
makeColor (r,g,b) = printf "#%02x%02x%02x" r b g

defaultConfig :: IO String -> IO UnitConfig
defaultConfig string = return UnitConfig{
    fontColor = return (0,0,0)
    , fontSize = return 9
    , backgroundColor = return (0,0,0)
    , font = return "monospace"
}