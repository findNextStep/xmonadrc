module TheNext.DefalutApp
    (
        terminal,
        explorer,
        webBrowser,
        screenLock,
        screenShutter,
        myClock,
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
screenLock = "dm-tool lock"

-- | 默认截图工具
screenShutter :: String
screenShutter = "shutter -s -e -n"

-- | 默认时钟程序
myClock :: String
myClock = "xclock -update 1 -bg black -norender -hd white -hl white -bd red -fg \"#325A8E\""