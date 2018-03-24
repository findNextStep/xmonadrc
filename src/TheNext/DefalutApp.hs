module TheNext.DefalutApp
    (
        terminal,
        webBrowser,
        launcher
    )where

terminal::String
terminal = "urxvt"

launcher::String
launcher = "dmenu_run"

-- | 默认浏览器
webBrowser::String
webBrowser = "google-chrome"