module Tests where

import Control.Monad
import GameOfLife
import Utils


-- ^ All tests
allTests :: IO ()
allTests = sequence_ [test1, test2]

-- ^ Stick pattern
test1 :: IO ()
test1 = do
   let input = [(0,1), (1,1), (2,1)]
       world = create 3 3 input
       worlds = iterateN 2 (computeSeq . step) world
       output = creaturePositions $ head worlds
   print (input == output)


-- ^ Frog pattern
test2 :: IO ()
test2 = do
   let input = [(0,2), (1,0), (1,3), (2,0), (2,3), (3,1)]
       world = create 4 4 input
       worlds = iterateN 2 (computeSeq . step) world
       output = creaturePositions $ head worlds
   print (input == output)