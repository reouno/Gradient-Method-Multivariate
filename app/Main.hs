module Main where

import Lib

main :: IO ()
main = do
    putStrLn "-----Gradient method（勾配法）for multivariate function-----\n"
    putStrLn "This program is sample of \"Gradient Method\"."
    putStrLn "This sample is for multivariate function."
    let f xs = (xs!!0 - xs!!2)^2 + (xs!!0 + xs!!1)^2 + (xs!!1 - 1)^2 + (2*xs!!3 + xs!!0 - xs!!1)^2 + (xs!!4 + xs!!0 - xs!!2)^2
    putStrLn "Function:  f(x1, x2, x3, x4, x5) = (x1 - x3)^2 + (x1 + x2)^2 + (x2 - 1)^2 + (2x4 + x1 - x2)^2 + (x5 + x1 - x3)^2"
    let as = replicate 5 1
    putStrLn $ "Initial value:  as = " ++ (show as)
    let minValues = find_min f as
    putStrLn $ "Local minimum value:  min = " ++ (show minValues)
    putStrLn $ "f(x1, x2, x3, x4, x5):  f(min) = " ++ (show $ f minValues)


-- 微分係数を計算するときにxに与える微小変化
h :: Double
h = 1.0e-7

-- 勾配法で使う、正の定数
epsilon :: Double
epsilon = 0.01

-- リストの特定の要素に任意の値を加える
update :: Num a => [a] -> Int -> a -> [a]
update as n a = (fst $ splitAt n as) ++ [(head $ snd $ splitAt n as) + a] ++(tail $ snd $ splitAt n as)

-- 偏微分を計算
differential :: ([Double] -> Double) -> [Double] -> [Double]
differential f as = map (differential' f as) [0..n-1]
    where
        n = length as
        differential' f as n = (f (update as n h) - f (update as n (-h))) / (2*h)

-- 値の更新
find_min :: ([Double] -> Double) -> [Double] -> [Double]
find_min f as =
    let
        gs = differential f as
        as' = zipWith (-) as $ map (*epsilon) gs
        gs' = differential f as'
    in
        if f as <= f as'
            then as
            else find_min f as'
