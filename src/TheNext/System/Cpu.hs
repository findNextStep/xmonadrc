module TheNext.System.Cpu(
    getCpuLoads
)where

import System.Information.StreamInfo(getLoad)
import Data.List                (sort)
import System.Directory         (getDirectoryContents)

getCpuNum = do
    num <- getDirectoryContents "/sys/bus/cpu/devices"
    return $ length num - 2

forAll ::(a -> b) -> [a] ->  [b]
forAll fun [] = []
forAll fun a  =  fun (head a) : forAll fun (tail a)

toInt = forAll (read ::String -> Integer)

cpuActive = do
    cpu <- readFile "/proc/stat"
    return $forAll sum(                         -- 求和
            forAll toInt(                       -- 转换为整数形式
            forAll(take 3)(                     -- 取前三个数
            forAll tail(                        -- 去掉开头的cpu标号
            forAll words                        -- 按空格分词
            (filter(\x -> take 3 x =="cpu") $   -- 选取包含cpu工作时间的行
            lines cpu)))))                      -- 分行
   
cpuTotal = do
    cpu <- readFile "/proc/stat"
    return $forAll sum(                         -- 求和
            forAll toInt(                       -- 转换为整数形式
            forAll tail(                        -- 去掉开头的cpu标号
            forAll words                        -- 按空格分词
            (filter(\x -> take 3 x =="cpu") $   -- 选取包含cpu工作时间的行
            lines cpu))))                       -- 分行

getCpuLoads::IO[Double]
getCpuLoads = getLoad 0.05 cpuActive