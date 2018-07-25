import System.Taffybar

import System.Taffybar.Systray
import System.Taffybar.TaffyPager
import System.Taffybar.SimpleClock
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.Weather
import System.Taffybar.MPRIS
import System.Taffybar.Pager
import System.Taffybar.NetMonitor

import System.Taffybar.Widgets.PollingBar
import System.Taffybar.Widgets.PollingGraph

import System.Information.Memory
import System.Information.CPU
import System.Taffybar.DiskIOMonitor

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

setFontSize size str = "<span font=\'" ++ size ++ "\'>" ++ str ++ "</span>"

main = do
  let memCfg = defaultGraphConfig { graphDataColors = [(1, 1, 1, 1)]
                                  , graphLabel = Just "mem"
                                  , graphBackgroundColor = (18/255,33/255,52/255)
                                  , graphBorderColor = (18/255,23/255,52/255)
                                  }
      cpuCfg = defaultGraphConfig { graphDataColors = [ (1, 1, 1, 1)
                                                      , (1, 1, 1, 0.5)
                                                      ]
                                  , graphBackgroundColor = (18/255,33/255,52/255)
                                  , graphLabel = Just "cpu"
                                  , graphBorderColor = (18/255,23/255,52/255)
                                  }
  let clock = textClockNew Nothing "<span>%F %T</span>" 1
      pager = taffyPagerNew defaultPagerConfig { activeWindow     = setFontSize "9" . colorize "#fff" "" . escape
                                               , activeLayout     = escape                                 
                                               , activeWorkspace  = wrap "-> " "" . escape
                                               , hiddenWorkspace  = colorize "#888" "" . escape
                                               , emptyWorkspace   = const ""
                                               , visibleWorkspace = colorize "#bbb" "" . wrap "(" ")" . escape
                                               , urgentWorkspace  = colorize "red" "yellow" . escape
                                               , widgetSep        = colorize "#325A8E" "" " | "
                                               }
      -- note = notifyAreaNew defaultNotificationConfig
      mpris = mprisNew defaultMPRISConfig
      mem = pollingGraphNew memCfg 1 memCallback
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      tray = systrayNew
      net = netMonitorNew 1 "wlp3s0"
  taffybarMain defaultTaffybarConfig { startWidgets = [ pager ] -- , note ]
                                        , endWidgets = [ tray, clock, mem, cpu, net ]
                                        , barPosition = Bottom
                                        , barHeight = 18
                                        , widgetSpacing = 1
                                        }
