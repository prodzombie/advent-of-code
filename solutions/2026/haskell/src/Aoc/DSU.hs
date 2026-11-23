module Aoc.DSU (DSU, new, find, unite, getSize, getRootSizes) where

import Control.Monad.ST (ST)
import Data.Array.ST (STUArray, getBounds, newArray, readArray, writeArray)
import qualified Data.IntSet as IntSet

-- Nonnegative entries are parent indices. Each root stores its negated set size.
newtype DSU s = DSU (STUArray s Int Int)

new :: Int -> ST s (DSU s)
new count = DSU <$> newArray (0, max 0 count - 1) (-1)

-- Element indices must be in [0, count).
find :: DSU s -> Int -> ST s Int
find dsu@(DSU entries) node = do
  parent <- readArray entries node
  if parent < 0
    then pure node
    else do
      root <- find dsu parent
      writeArray entries node root
      pure root

unite :: DSU s -> Int -> Int -> ST s Bool
unite dsu@(DSU entries) a b = do
  rootA <- find dsu a
  rootB <- find dsu b
  if rootA == rootB
    then pure False
    else do
      sizeA <- readArray entries rootA
      sizeB <- readArray entries rootB
      let (larger, smaller) = if sizeA > sizeB then (rootB, rootA) else (rootA, rootB)
      writeArray entries smaller larger
      writeArray entries larger (sizeA + sizeB)
      pure True

getSize :: DSU s -> Int -> ST s Int
getSize dsu@(DSU entries) node = do
  root <- find dsu node
  negate <$> readArray entries root

getRootSizes :: DSU s -> ST s [Int]
getRootSizes dsu@(DSU entries) = do
  (_, upper) <- getBounds entries
  go upper 0 IntSet.empty []
  where
    go upper node seen result
      | node > upper = pure (reverse result)
      | otherwise = do
          root <- find dsu node
          if IntSet.member root seen
            then go upper (node + 1) seen result
            else do
              size <- negate <$> readArray entries root
              go upper (node + 1) (IntSet.insert root seen) (size : result)
