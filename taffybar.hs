module Main where

import System.Information.CPU
import System.Information.Memory
import System.Taffybar
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.SimpleClock
import System.Taffybar.Systray
import System.Taffybar.Weather
import System.Taffybar.Widgets.PollingGraph
import System.Taffybar.TaffyPager
import System.Taffybar.Battery
import System.Taffybar.MPRIS
import System.Taffybar.NetMonitor
memCallback :: IO [Double]
memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback :: IO [Double]
cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad,userLoad]

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
      battery = batteryBarNew defaultBatteryConfig 10
      mpris = mprisNew defaultMPRISConfig
      mem = pollingGraphNew memCfg 1 memCallback
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      tray = systrayNew
  defaultTaffybar defaultTaffybarConfig { startWidgets = [  pager,note ]
                                        , endWidgets = [ tray,network, battery , clock, mem, cpu, mpris ]
                                        , barHeight     = 18
                                        }
