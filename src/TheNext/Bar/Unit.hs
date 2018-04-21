module TheNext.Bar.Unit (
    addConfig,
    pager,
    unitBase
) where

import qualified Graphics.UI.Gtk as Gtk
import System.Taffybar.Widgets.PollingLabel         (pollingLabelNew)
import Text.Printf                                  (printf)
import Graphics.UI.Gtk.Misc.TrayManager
import System.Taffybar.TaffyPager
import System.Taffybar.WorkspaceHUD
import System.Taffybar.Pager as Pager

data UnitConfig = UnitConfig{ fontColor :: IO (Int,Int,Int)
                            , fontSize :: IO Int
                            , backgroundColor ::IO (Int,Int,Int)
                            , font :: IO String
                            }
unitBase :: IO String -> IO Gtk.Widget
unitBase content = do
    l <- pollingLabelNew "waitForInit" 1 content
    Gtk.widgetShowAll l
    return $ Gtk.toWidget l

pager = taffyPagerHUDNew (defaultPagerConfig
    { activeWindow            = escape
    , activeLayout            = escape
    , activeWorkspace         = colorize "yellow" "" . wrap "[" "]" . escape
    , hiddenWorkspace         = escape
    , emptyWorkspace          = const ""
    , visibleWorkspace        = wrap "(" ")" . escape
    , urgentWorkspace         = colorize "red" "yellow" . escape
    , widgetSep               = "|"
    , workspaceBorder         = False
    , workspaceGap            = 0
    , workspacePad            = False
    , useImages               = True
    , imageSize               = 16
    , fillEmptyImages         = True
    })$ defaultWorkspaceHUDConfig
    { widgetBuilder = buildUnderlineButtonController
    , widgetGap = 0
    , windowIconSize = 16
    , underlineHeight = 4
    , minWSWidgetSize = Just 30
    , underlinePadding = 1
    , maxIcons = Just 4
    , minIcons = 0
    , getIconInfo = defaultGetIconInfo
    , labelSetter = return . workspaceName
    , updateIconsOnTitleChange = True
    , updateOnWMIconChange = False
    , showWorkspaceFn = hideEmpty
    , borderWidth = 0
    , updateRateLimitMicroseconds = 100000
    , debugMode = False
    , redrawIconsOnStateChange = False
    , urgentWorkspaceState = False
    , innerPadding = 0
    , outerPadding = 0
    }

addConfig :: IO String -> (IO String -> IO UnitConfig) -> IO String
addConfig content configFun = do
    config <- configFun content
    input <- content
    myfont <- font config
    myfontSize <- fontSize config
    (fr,fb,fg) <- fontColor config
    return ("<span font='" ++
        myfont ++ " "   ++
        printf "%d" myfontSize ++ "' fgcolor='"++
        makeColor (fr,fg,fb)++ "'>"  ++ input ++ "%</span>")

makeColor :: (Int,Int,Int) -> String
makeColor (r,g,b) = printf "#%02x%02x%02x" r b g

defaultConfig :: IO String -> IO UnitConfig
defaultConfig string = return UnitConfig{
    fontColor = return (0,0,0)
    , fontSize = return 9
    , backgroundColor = return (0,0,0)
    , font = return "monospace"
}