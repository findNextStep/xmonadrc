module TheNext.Bar.Unit (
) where

import qualified Graphics.UI.Gtk as Gtk
import System.Taffybar.Widgets.PollingLabel         (pollingLabelNew) 

data UnitConfig = UnitConfig{ fontColor :: (Int,Int,Int)
                            , fontSize :: Int
                            , backgroundColor :: (Int,Int,Int)
                            , font :: String
                            }
unitBase ::IO String -> IO Gtk.Widget 
unitBase content = do
    l <- pollingLabelNew "waitForInit" 1 content
    Gtk.widgetShowAll l
    return $ Gtk.toWidget l 

unitBase :: IO String -> UnitConfig -> IO Gtk.Widget
unitBase content config = do 
    l <- pollingLabelNew "waitForInit" 1 content
    Gtk.widgetShowAll l
    return $ Gtk.toWidget l 


addConfig :: IO String -> UnitConfig -> IO String
addConfig content config = "<span font='" ++ config.font ++ " " ++ config.fontSize ++ "' fgcolor='"++makeColor [head cpu,1.0-head cpu,0.0]++"'>cpu"  ++ "test"++ "%</span>"