module GameOfLifeIO (
   fromGifFile,
   toGifFile,
) where

import Codec.Picture
import Codec.Picture.Gif
import Codec.Picture.Repa as CR
import Control.Parallel.Strategies
import Data.Array.Repa as Repa
import qualified Data.Vector.Storable as V
import Data.Word
import GameOfLife
import Prelude as P


-- | Read the initial GIF file
fromGifFile :: FilePath -> IO WorldState
fromGifFile path = do
   res <- CR.readImageRGBA path
   case res of
      Left errorMsg -> error errorMsg
      Right gifImag -> return $ decodeGIF gifImag


-- Decoding a GIF gives the R G B components
decodeGIF :: Img RGBA -> WorldState
decodeGIF arr =
   let isBlack :: (Word8, Word8, Word8) -> Bool
       isBlack (r,g,b) = all (==0) [r,g,b]
   in computeS $ Repa.map isBlack (collapseColorChannel arr)


-- | Save a sequence of world as an animated GIF file
toGifFile :: FilePath -> [WorldState] -> IO ()
toGifFile path worlds = do
   let images = P.map encodeToGreyScale worlds `using` parList rdeepseq
       res = writeGifImages path LoopingForever images
   case res of
      Left errorMsg -> error errorMsg
      Right sideEff -> sideEff


{-
Encoding a GIF requires to have a palette: although, GIF is able to encore each of (R,G,B) combination,
only 256 of them are available in a given image (the limited choice is described by the palette)
-}
encodeToGreyScale :: WorldState -> (Palette, GifDelay, Image Pixel8)
encodeToGreyScale world =
   let (Z:.w:.h) = extent world
       encode True = 0
       encode False = 255
       pixels = (V.fromList . toList . computeUnboxedS . Repa.map encode) world
   in (greyPalette, 5, Image h w pixels)

