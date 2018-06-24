module TheNext.System.Voice(
    mute,
    volumeIncrease,
    volumeDecrease,
    readVolume
)where

import XMonad.Core     (spawn)
import System.Process  (readProcess)
import Text.Regex.Posix
import Control.Monad.Reader(MonadIO())

-- | 读取音量
readVolume :: IO Integer
readVolume = do
    test <- readProcess "amixer" [] []
    let re = test =~ "Mono: Playback [0-9]* \\[[0-9]*" :: String
    let vo =read (tail (re =~ "\\[[0-9]+" :: String)) :: Integer
    return vo

-- | 静音
mute ::   MonadIO m => m ()
mute =  spawn "pactl set-sink-volume 0 0"

-- | 音量增加
volumeIncrease :: MonadIO m => Int -> m()
volumeIncrease size = spawn $ "pactl set-sink-volume 0 +" ++ show size ++ "%"

-- | 音量减少
volumeDecrease :: MonadIO m => Int -> m()
volumeDecrease size = spawn $ "pactl set-sink-volume 0 +" ++ show size ++ "%"