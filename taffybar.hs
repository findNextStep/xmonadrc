import System.Taffybar

import System.Taffybar.Systray
import System.Taffybar.TaffyPager
import System.Taffybar.SimpleClock
import System.Taffybar.Pager
import System.Taffybar.NetMonitor

import System.Taffybar.Widgets.PollingBar
import System.Taffybar.Widgets.PollingGraph
import System.Taffybar.Widgets.PollingLabel

import System.Information.Memory
import System.Information.CPU
import System.Taffybar.DiskIOMonitor

import TheNext.System.Voice
import TheNext.System.Battery
import Graphics.UI.Gtk
memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

font = "ubuntu mono bold 12"

getVoice = do
  volume <- readVolume
  return $ setFontSize font ((if volume > 1 then "🔊 " else "🔈 ") ++ show volume ++ "% ")

getBatteryState = do
  battery <- getBattery
  charge <- isCharge
  return $ setFontSize font ((if charge then "🗲" else "🔋") ++ "" ++ show battery ++ "%   ")
setFontSize size str = "<span font=\'" ++ size ++ "\'>" ++ str ++ "</span>"

getfreq = do
  ischarge <- isCharge
  if ischarge then return 1.0 else return 10.0

main = do
  let memCfg = defaultGraphConfig { graphDataColors = [(1, 1, 1, 1)]
                                  , graphLabel = Just $ setFontSize font "🍱"
                                  , graphBackgroundColor = (0/255,0/255,0/255)
                                  , graphBorderColor = (128/255,128/255,128/255)
                                  }
      cpuCfg = defaultGraphConfig { graphDataColors = [ (1, 1, 1, 1)
                                                      , (1, 1, 1, 0.5)
                                                      ]
                                  , graphLabel = Just $ setFontSize font "💻"
                                  , graphBackgroundColor = (0/255,0/255,0/255)
                                  , graphBorderColor = (128/255,128/255,128/255)
                                  }
  freq <- getfreq
  let clock = textClockNew Nothing (setFontSize font "<span>%F %T</span>") freq
      pager = taffyPagerNew defaultPagerConfig { activeWindow     = setFontSize font . colorize "#fff" "" . escape . shorten 50
                                               , activeLayout     = setFontSize font . escape . take 4
                                               , activeWorkspace  = setFontSize font . wrap "-> " "" . escape
                                               , hiddenWorkspace  = setFontSize font . colorize "#888" "" . escape
                                               , emptyWorkspace   = const ""
                                               , visibleWorkspace = setFontSize font . colorize "#bbb" "" . wrap "(" ")" . escape
                                               , urgentWorkspace  = setFontSize font . colorize "red" "yellow" . escape
                                               , widgetSep        = setFontSize font (colorize "#666" "" "|")
                                               }
      mem = pollingGraphNew memCfg freq memCallback
      cpu = pollingGraphNew cpuCfg freq cpuCallback
      tray = systrayNew
      net = netMonitorNewWith freq "wlp3s0" 2 $ setFontSize font "⏬$inKB$kb/s\t⏫$outKB$kb/s\t"
      voice = do
        l <- pollingLabelNew "voice " freq getVoice
        widgetShowAll l
        return l
      battery = do
        l <- pollingLabelNew "battery" freq getBatteryState
        widgetShowAll l
        return l
      io = dioMonitorNew defaultGraphConfig { graphDataColors = [(1, 1, 1, 1)]
                                            , graphLabel = Just $ setFontSize font "💽"
                                            , graphBackgroundColor = (0/255,0/255,0/255)
                                            , graphBorderColor = (128/255,128/255,128/255)
                                            } freq "sdc"
  taffybarMain defaultTaffybarConfig { startWidgets = [ pager ]
                                        , endWidgets = [ tray, clock, mem, cpu, io, battery, voice, net ]
                                        , barPosition = Bottom
                                        , barHeight = 18
                                        , widgetSpacing = 1
                                        }
