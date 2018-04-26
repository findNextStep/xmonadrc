module TheNext.Bar.ShowPower(
    powerShower,
    powerText,
    powerUnit,
    powerGetter
) where

import System.Process                       (readProcess)
import TheNext.Bar.Taffybar.Widgets.PollingBar
import TheNext.Bar.Unit                     (unitBase)
import Graphics.UI.Gtk
import Graphics.UI.Gtk.Abstract.Widget      (widgetSetSizeRequest)
import Text.Printf                          (printf)
import Control.Concurrent
import Control.Monad ( forever )

-- | 获取某个电池的状态
powerGetter :: String -> IO Double
powerGetter batter = do
    battery <- readProcess "cat" ["/sys/class/power_supply/" ++ batter ++ "/capacity"] ""
    return ((read battery :: Double) / 100)

-- | 判断当前电脑是否处于充电状态
isAC :: IO Bool
isAC = do
    ac <- readProcess "cat" ["/sys/class/power_supply/AC/online"] "" 
    if (read ac :: Int) == 1
        then return True
        else return False

batteryConfig :: BarConfig
batteryConfig = BarConfig { barBorderColor = (0.5, 0.5, 0.5)
    , barBackgroundColor = const (0x12/256.0, 
                                  0x21/256.0, 
                                  0x34/255.0)
    , barColor = colorFunc
    , barPadding = 1
    , barWidth = 12
    , barDirection = HORIZONTAL
    }
    where
        colorFunc pct = (1-pct,pct,0)

powerShower :: IO Widget
powerShower = pollingBarNew batteryConfig 2  $ powerGetter "BAT0" 

powerText :: IO Widget
powerText = unitBase pow
    where
        pow = do
            power <- powerGetter "BAT0" 
            ac <- isAC
            if ac
                then return ("$" ++ printf "%2.0f" (power*100) ++ "%")
                else return ("*" ++ printf "%2.0f" (power*100) ++ "%")

powerUnit :: IO Widget
powerUnit = do
    vbox <- vBoxNew False 0
    power <- powerShower
    boxPackStart vbox power PackNatural 0
    text  <- powerText
    boxPackStart vbox text  PackNatural 0
    _ <- forkIO $ forever $ do
        widgetShowAll vbox
        threadDelay $ floor (1 * 1000000)
    widgetShowAll vbox
    return $ toWidget vbox