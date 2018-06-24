module TheNext.System.Voice(
    mute,
    volumeIncrease,
    volumeDecrease
)where

import XMonad.Core  (spawn)

import Control.Monad.Reader(MonadIO())
-- | 静音
mute ::   MonadIO m => m ()
mute =  spawn "pactl set-sink-volume 0 0"

-- | 音量增加
volumeIncrease :: MonadIO m => Int -> m()
volumeIncrease size = spawn $ "pactl set-sink-volume 0 +" ++ show size ++ "%"

-- | 音量减少
volumeDecrease :: MonadIO m => Int -> m()
volumeDecrease size = spawn $ "pactl set-sink-volume 0 +" ++ show size ++ "%"