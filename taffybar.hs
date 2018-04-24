import System.Information.CPU2                      (getCPULoad)
import System.Information.Memory                    (parseMeminfo,memoryUsedRatio)
import System.Taffybar.FreedesktopNotifications     (notifyAreaNew,defaultNotificationConfig)
import System.Taffybar.SimpleClock                  (textClockNew)
import System.Taffybar.MPRIS                        (mprisNew,defaultMPRISConfig)
import Text.Printf                                  (printf)
import System.Process                               (readProcess)
import System.Taffybar.Systray                      (systrayNew)
import TheNext.Bar.Unit                             (unitBase,pager)
import TheNext.Bar.AutoNetMonitor                   (autoNetMonitorWithout)
import System.Taffybar       as Taffybar
import System.Taffybar.Menu.MenuWidget
import TheNext.Bar.ShowPower

getVolume :: IO String
getVolume = do
  cmd <- readProcess "pactl" ["list","sinks"] []
  return $ words (lines cmd !! 9) !! 3

memCallback :: IO [Double]
memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

toInt :: Double -> Int
toInt = round

makeColor :: [Double]-> String
makeColor color = printf "#%02x%02x%02x" (toInt(head color * 255)) (toInt(color!!1 * 255)) (toInt(last color * 255))

computerInfo ::IO String
computerInfo = do
  cpu <- getCPULoad "cpu"
  mem <- memCallback
  let
    cpuBar = "<span font='monospace 9' fgcolor='"++makeColor [head cpu,1.0-head cpu,0.0]++"'>cpu"  ++ printf "%02.0f"(head cpu * 100) ++ "%</span>"
    memBar = "<span font='monospace 9' fgcolor='"++makeColor [head mem,1.0-head mem,0.0]++"'>mem"  ++ printf "%02.0f"(head mem * 100) ++ "%</span>"
  return (cpuBar ++ "\n" ++ memBar)

main :: IO ()
main = do
  let clock = textClockNew Nothing "<span font='monospace 9' fgcolor='#fff'>%m-%d %u\n%H:%M 周</span>" 30
      networkWire = autoNetMonitorWithout ["lo"]
      note = notifyAreaNew defaultNotificationConfig
      battery = powerUnit
      mpris = mprisNew defaultMPRISConfig
      info = unitBase computerInfo
      volume = unitBase getVolume
      tray = systrayNew
      menu = menuWidgetNew $ Just "PREFIX-"
  Taffybar.taffybarMain Taffybar.defaultTaffybarConfig
                                    { Taffybar.barHeight     = 28
                                    , Taffybar.monitorNumber = 0
                                    , Taffybar.startWidgets  = [pager,note]
                                    , Taffybar.endWidgets    = [tray,battery,clock,mpris,info,volume,networkWire,menu]
                                    , Taffybar.widgetSpacing = 5
                                    }
