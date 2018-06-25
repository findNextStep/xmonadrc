module TheNext.System.Cpu(
    getCpuLoads
)where

import System.Information.CPU2  (getCPULoad)
import Data.List                (sort)

readCpuLoad i = do
    load <- getCPULoad ("cpu" ++ show i)
    return [head load + load !! 1]

loop 0 = readCpuLoad 0

loop a = do
    sub <- loop (a-1)
    this <- readCpuLoad a 
    return $ sub ++ this

getCpuLoads::IO[Double]
getCpuLoads = do
    cpus <- loop 7
    return $ sort cpus