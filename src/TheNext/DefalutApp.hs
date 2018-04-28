module TheNext.DefalutApp
    (
        terminal,
        explorer,
        webBrowser,
        screenLock,
        screenShutter,
        launcher
    )where

terminal::String
terminal = "gnome-terminal"

launcher::String
launcher = "dmenu_run"

-- | 默认浏览器
webBrowser::String
webBrowser = "google-chrome --disable-gpu"

explorer :: String
explorer = "nemo"

-- | 默认锁屏程序 
screenLock :: String
screenLock = "gnome-screensaver-command -l"

-- | 默认截图工具
screenShutter :: String
screenShutter = "shutter -s"