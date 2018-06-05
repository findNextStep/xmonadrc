module TheNext.System.Battery(
    getBattery,
    isCharge,
    checkIfHasBattery
)where

import System.Directory(doesDirectoryExist)

-- get how many battery the laptop have
getBattery :: IO Int
getBattery = do
    power <- readFile "/sys/class/power_supply/BAT0/capacity"
    return (read power :: Int)

-- if the laptop is charging
isCharge :: IO Bool
isCharge = do 
    isCharging <- readFile "/sys/class/power_supply/AC/online"
    return ((read isCharging ::Int) == 1)

-- check if this is a laptop
-- this code not been checked in PC
-- TODO
checkIfHasBattery :: IO Bool
checkIfHasBattery = doesDirectoryExist "/sys/class/power_supply/BAT0"