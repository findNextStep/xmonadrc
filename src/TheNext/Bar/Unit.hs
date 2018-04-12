module TheNext.Bar.Unit (
    addConfig,
    unitBase
) where

import qualified Graphics.UI.Gtk as Gtk
import System.Taffybar.Widgets.PollingLabel         (pollingLabelNew) 
import Text.Printf                                  (printf)

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