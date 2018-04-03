import System.Information.CPU2                      (getCPULoad)
import System.Information.Memory                    (parseMeminfo,memoryUsedRatio)
import System.Taffybar.FreedesktopNotifications     (notifyAreaNew,defaultNotificationConfig)
import System.Taffybar.SimpleClock                  (textClockNew)
import System.Taffybar.Systray                      (systrayNew)
import System.Taffybar.TaffyPager                   (taffyPagerHUDLegacy,defaultPagerConfig)
import System.Taffybar.Battery                      (batteryBarNew)
import System.Taffybar.MPRIS                        (mprisNew,defaultMPRISConfig)
import System.Taffybar.NetMonitor                   (netMonitorMultiNewWith)
import System.Taffybar.Widgets.VerticalBar          (defaultBarConfig,BarConfig(..))
import System.Taffybar.Widgets.PollingLabel         (pollingLabelNew) 
import Text.Printf                                  (printf)
import qualified Graphics.UI.Gtk as Gtk
import System.Taffybar
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

batteryConfig :: BarConfig
batteryConfig =
  defaultBarConfig colorFunc
  where
    colorFunc pct = (1-pct,pct,0)

main :: IO ()
main = do
  let clock = textClockNew Nothing "<span font='monospace 9' fgcolor='#fff'>%m月%d日\n周%u %H:%M</span>" 30
      pager = taffyPagerHUDLegacy defaultPagerConfig
      network = netMonitorMultiNewWith 1 ["enp4s0f1", "wlp3s0"] 2 "<span font='monospace 10' fgcolor='#fff'>$inKB$kb/s▼\n$outKB$kb/s▲</span>"
      note = notifyAreaNew defaultNotificationConfig
      battery = batteryBarNew batteryConfig 10
      mpris = mprisNew defaultMPRISConfig
      info = do
        l <- pollingLabelNew "233" 1 computerInfo
        Gtk.widgetShowAll l
        return $ Gtk.toWidget l
      tray = systrayNew
  defaultTaffybar defaultTaffybarConfig { startWidgets = [  pager,note ]
                                        , endWidgets = [ tray,battery,clock,info,mpris,network]
                                        , barHeight     = 32
                                        }
