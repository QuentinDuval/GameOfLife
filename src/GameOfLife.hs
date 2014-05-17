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
import Data.Array.Repa.Stencil
import Data.Array.Repa.Stencil.Dim2
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
step world = Repa.map step' $
               mapStencil2 (BoundFixed 0) gameOfLifeMask world'
   where
      {-# INLINE step' #-}
      step' :: Int -> Bool
      step' x = x == 3 || x == 12 || x == 13 -- Using elem makes it real slow
      
      {-# INLINE world' #-}
      world' :: Array D DIM2 Int
      world' = Repa.map (\v -> if v then 1 else 0) world
      
      {-# INLINE gameOfLifeMask #-}
      gameOfLifeMask :: Stencil DIM2 Int
      gameOfLifeMask = 
         [stencil2| 1  1  1
                    1 10  1
                    1  1  1 |]

