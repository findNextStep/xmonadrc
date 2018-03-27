module Main where

import System.Information.CPU
import System.Information.Memory
import System.Taffybar
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.MPRIS
import System.Taffybar.SimpleClock
import System.Taffybar.Systray
import System.Taffybar.TaffyPager()
import System.Taffybar.Weather
import System.Taffybar.Widgets.PollingBar()
import System.Taffybar.Widgets.PollingGraph
import System.Taffybar.WorkspaceHUD
import System.Taffybar.Battery
memCallback :: IO [Double]
memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback :: IO [Double]
cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad,userLoad]

-- userCpuCallback :: IO [Double]
-- userCpuCallback = do
--   (userLoad, systemLoad, totalLoad) <- cpuLoad
--   return [totalLoad, systemLoad]
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
  let clock = textClockNew Nothing "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
      -- pager = hudFromPagerConfig defaultWorkspaceHUDConfig
      note = notifyAreaNew defaultNotificationConfig
      battery = batteryBarNew defaultBatteryConfig 10
      wea = weatherNew (defaultWeatherConfig "KMSN") 10
      mpris = mprisNew defaultMPRISConfig
      mem = pollingGraphNew memCfg 1 memCallback
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      tray = systrayNew
  defaultTaffybar defaultTaffybarConfig { startWidgets = [  note ]
                                        , endWidgets = [ tray, battery ,wea, clock, mem, cpu, mpris ]
                                        , barHeight     = 18
                                        }
