module Main where

import Data.Time
import GameOfLife
import GameOfLifeIO
import System.Environment
import Utils


-- 28,1 s
-- 8,6s

main :: IO()
main = do
   args <- getArgs
   if length args < 3
      then
         error "3 arguments needed: input file, output file and number of iterations."
      else
         let (input : output : iterNb : _) = args
         in runGame input output (read iterNb)


runGame :: String -> String -> Int -> IO()
runGame inputFile outputFile iterCount = do
   initWorld <- fromGifFile inputFile
   let nthWorld = iterateN iterCount (computePar . step) initWorld
   toGifFile outputFile nthWorld

