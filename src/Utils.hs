module Utils where


iterateN :: Int -> (a -> a) -> a -> [a]
iterateN n f = take (n + 1) . iterate f
