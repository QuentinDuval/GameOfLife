module GameOfLife (
   WorldState,
   WorldComput,
   create,
   creaturePositions,
   step,
   computePar,
   computeSeq,
) where

import Control.Arrow
import Control.Monad
import Control.Monad.Identity
import Data.Array.Repa as Repa
import Data.Maybe
import Prelude as P


-- | The world: each box may contain one individual
type World r = Array r DIM2 Bool -- Hidden
type WorldState = World U
type WorldComput = World D


-- | Create a world based on the initial position of the creatures
create :: Int -> Int -> [(Int, Int)] -> WorldState
create width height coordinates =
   let isCreature (Z:.i:.j) = (i, j) `elem` coordinates 
   in computeSeq $ fromFunction (Z:.width:.height) isCreature


-- | Returns the coordinates at which the creates are
creaturePositions :: WorldState -> [(Int, Int)]
creaturePositions world = catMaybes $ toList allPositions
   where
      allPositions = fromFunction (extent world) coords
      coords pos@(Z:.i:.j) = if world ! pos then Just (i,j) else Nothing
      

-- | Compute the world (parallel)
computePar :: WorldComput -> WorldState
computePar = runIdentity . computeUnboxedP


-- | Compute the world (sequential)
computeSeq :: WorldComput -> WorldState
computeSeq = computeUnboxedS


-- | Advance the world one step further
step :: (Source r Bool) => World r -> WorldComput
step world = fromFunction (extent world) cellStatus
   where
      cellStatus = uncurry isAlive . ((world !) &&& neighCount)
      neighCount = length . filter (==True) . neighbors world


isAlive :: Bool -> Int -> Bool
isAlive True n = n `elem` [2, 3]
isAlive False n = n == 3


neighbors :: (Source r Bool) => World r -> DIM2 -> [Bool]
neighbors world pos =
   let indexes = neighborIndexes (extent world) pos
   in P.map ((world !) . uncurry ix2) indexes


neighborIndexes :: DIM2 -> DIM2 -> [(Int, Int)]
neighborIndexes (Z:.w:.h) (Z:.x:.y) = filter (/= (x,y)) allNeigh
   where
      allNeigh = [(i,j) | i <- around x w, j <- around y h]
      around n max = filter (0 <=) . filter (< max) $ [n-1, n, n+1]
