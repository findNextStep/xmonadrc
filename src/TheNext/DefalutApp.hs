module TheNext.DefalutApp
    (
        terminal,
        explorer,
        webBrowser,
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
explorer = "nautilus --no-desktop"