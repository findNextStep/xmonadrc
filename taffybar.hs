import System.Information.CPU2                      (getCPULoad)
import System.Information.Memory                    (parseMeminfo,memoryUsedRatio)
import System.Taffybar.FreedesktopNotifications     (notifyAreaNew,defaultNotificationConfig)
import System.Taffybar.SimpleClock                  (textClockNew)
import System.Taffybar.Systray                      (systrayNew)
import System.Taffybar.TaffyPager                   (taffyPagerHUDLegacy,defaultPagerConfig)
import System.Taffybar.Battery                      (batteryBarNew)
import System.Taffybar.MPRIS                        (mprisNew,defaultMPRISConfig)
import System.Taffybar.NetMonitor                   (netMonitorMultiNew)
import System.Taffybar.Widgets.VerticalBar          (defaultBarConfig,BarConfig(..))
import System.Taffybar
import System.Taffybar.Widgets.PollingGraph
memCallback :: IO [Double]
memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

batteryConfig :: BarConfig
batteryConfig =
  defaultBarConfig colorFunc
  where
    colorFunc pct = (1-pct,pct,0)

main :: IO ()
main = do
  let memCfg = defaultGraphConfig {
        graphDataColors = [(1, 0, 0, 1)]
          , graphLabel = Just "mem"
      }
      cpuCfg = defaultGraphConfig {
        graphDataColors = [(0, 1, 0, 1)
          , (1, 0, 1, 1)
        ]
        , graphLabel = Just "cpu"
      }
  let clock = textClockNew Nothing "<span fgcolor='#fff'>%m-%d 星期%u %H:%M</span>" 30
      pager = taffyPagerHUDLegacy defaultPagerConfig
      network = netMonitorMultiNew 2 ["enp4s0f1", "wlp3s0"]
      note = notifyAreaNew defaultNotificationConfig
      battery = batteryBarNew batteryConfig 10
      mpris = mprisNew defaultMPRISConfig
      mem = pollingGraphNew memCfg 1 memCallback
      cpu = pollingGraphNew cpuCfg 0.5 $ getCPULoad "cpu"
      tray = systrayNew
  defaultTaffybar defaultTaffybarConfig { startWidgets = [  pager,note ]
                                        , endWidgets = [ tray,network, battery , clock, mem, cpu, mpris ]
                                        , barHeight     = 18
                                        }
