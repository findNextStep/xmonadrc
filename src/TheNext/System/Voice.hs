module TheNext.System.Voice(
    mute,
    volumeIncrease,
    volumeDecrease,
    volumeSet,
    readVolume
)where

import XMonad.Core     (spawn)
import System.Process  (readProcess)
import Text.Regex.Posix
import Control.Monad.Reader(MonadIO())

-- | 读取音量以百分比为计
readVolume :: IO Int
readVolume = do
    test <- readProcess "amixer" [] []
    return (fromInteger (read (tail ((test =~ "Mono: Playback [0-9]* \\[[0-9]*" :: String) =~ "\\[[0-9]+" :: String)) :: Integer)::Int)

-- | 静音
mute ::   MonadIO m => m ()
mute =  spawn "pactl set-sink-volume 0 0"

-- | 音量增加
volumeIncrease :: MonadIO m => Int -> m()
volumeIncrease size = spawn $ "pactl set-sink-volume 0 +" ++ show size ++ "%"

-- | 音量减少
volumeDecrease :: MonadIO m => Int -> m()
volumeDecrease size = spawn $ "pactl set-sink-volume 0 +" ++ show size ++ "%"

-- | 设定音量
volumeSet :: MonadIO m => Int -> m()
volumeSet volume =  do
    mute
    volumeIncrease volume