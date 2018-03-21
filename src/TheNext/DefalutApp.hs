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

-- | const my web browser
webBrowser::String
webBrowser = "google-chrome"