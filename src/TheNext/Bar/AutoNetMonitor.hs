module TheNext.Bar.AutoNetMonitor(
    autoNetMonitor,
    autoNetMonitorWithout
)where

import qualified Graphics.UI.Gtk as Gtk
import System.Taffybar.NetMonitor   (netMonitorMultiNewWith)

import System.Process               (readProcess)
import Data.List                    ((\\))

-- | 获取某个文件夹内的文件列表
lsFile :: String -> IO [String]
lsFile path = do
    file <- readProcess "ls" [path] ""
    return $ lines file

-- | 获取所有网络设备的总网络用量的和
autoNetMonitor :: IO Gtk.Widget
autoNetMonitor = do
    device <- lsFile "/sys/class/net"
    netMonitorMultiNewWith 0.5 device 2 "<span font='monospace 10' fgcolor='#fff'>$inKB$kb/s▼\n$outKB$kb/s▲</span>"

-- | 获取除了设置的参数以外所有网络设备的网络用量总和
-- 示例：
-- autoNetMonitorWithout ["lo"]
autoNetMonitorWithout :: [String] -> IO Gtk.Widget
autoNetMonitorWithout remove = do
    device <- lsFile "/sys/class/net"
    netMonitorMultiNewWith 0.5 (device \\ remove ) 2 "<span font='monospace 10' fgcolor='#fff'>$inKB$kb/s▼\n$outKB$kb/s▲</span>"