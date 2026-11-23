module Aoc.DSU (DSU, new, find, unite, getSize, getRootSizes) where

import Control.Monad.ST (ST)
import Data.Array.ST (STUArray, getBounds, newArray, newListArray, readArray, writeArray)
import qualified Data.IntSet as IntSet

data DSU s = DSU !(STUArray s Int Int) !(STUArray s Int Int)

new :: Int -> ST s (DSU s)
new count = DSU <$> newListArray bounds [0..upper] <*> newArray bounds 1
  where
    upper = max 0 count - 1
    bounds = (0, upper)

-- Element indices must be in [0, count).
find :: DSU s -> Int -> ST s Int
find dsu@(DSU parents _) node = do
  parent <- readArray parents node
  if parent == node
    then pure node
    else do
      root <- find dsu parent
      writeArray parents node root
      pure root

unite :: DSU s -> Int -> Int -> ST s Bool
unite dsu@(DSU parents sizes) a b = do
  ra <- find dsu a
  rb <- find dsu b
  if ra == rb
    then pure False
    else do
      sa <- readArray sizes ra
      sb <- readArray sizes rb
      let (larger, smaller) = if sa < sb then (rb, ra) else (ra, rb)
      writeArray parents smaller larger
      writeArray sizes larger (sa + sb)
      pure True

getSize :: DSU s -> Int -> ST s Int
getSize dsu@(DSU _ sizes) node = find dsu node >>= readArray sizes

getRootSizes :: DSU s -> ST s [Int]
getRootSizes dsu@(DSU parents sizes) = do
  (_, upper) <- getBounds parents
  go upper 0 IntSet.empty []
  where
    go upper node seen result
      | node > upper = pure (reverse result)
      | otherwise = do
          root <- find dsu node
          if IntSet.member root seen
            then go upper (node + 1) seen result
            else do
              size <- readArray sizes root
              go upper (node + 1) (IntSet.insert root seen) (size : result)
