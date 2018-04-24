-- | copy from System.Taffybar.Widgets.PollingBar in taffybar stable-0.5
-- can see in https://github.com/travitch/taffybar/blob/stable-0.5/src/System/Taffybar/Widgets/PollingBar.hs
-- | 从taffybar 项目中复制并稍加修改

-- | Like the vertical bar, but this widget automatically updates
-- itself with a callback at fixed intervals.
module TheNext.Bar.Taffybar.Widgets.PollingBar (
  -- * Types
  VerticalBarHandle,
  BarConfig(..),
  BarDirection(..),
  -- * Constructors and accessors
  pollingBarNew,
  defaultBarConfig
  ) where

import Control.Concurrent
import qualified Control.Exception.Enclosed as E
import Control.Monad ( forever )
import Graphics.UI.Gtk

import TheNext.Bar.Taffybar.Widgets.VerticalBar

pollingBarNew :: BarConfig -> Double -> IO Double -> IO Widget
pollingBarNew cfg pollSeconds action = do
  (drawArea, h) <- verticalBarNew cfg

  _ <- on drawArea realize $ do
    _ <- forkIO $ forever $ do
      esample <- E.tryAny action
      case esample of
        Left _ -> return ()
        Right sample -> verticalBarSetPercent h sample
      threadDelay $ floor (pollSeconds * 1000000)
    return ()

  return drawArea