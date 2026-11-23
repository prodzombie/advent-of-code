{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

module Aoc.Grid
  ( Grid, Direction, dirs, inBounds, fromRows, readGrid, cellAt, countNeighborsWhere
  , findCell, movePoint, raycast
  ) where

import Aoc.Geometry (Point(Point2D))
import Aoc.Parse (readLines)
import Data.List (find)
import qualified Data.Map.Strict as Map

type Direction = (Integer, Integer) -- (dy, dx)
-- Keys put the row first so ascending traversal follows reading order.
newtype Grid a = Grid (Map.Map (Integer, Integer) a)

dirs :: [Direction]
dirs = [(dy, dx) | dy <- [-1..1], dx <- [-1..1], (dy, dx) /= (0, 0)]

inBounds :: Point 2 -> Integer -> Integer -> Bool
inBounds (Point2D col row) height width =
  0 <= row && row < height && 0 <= col && col < width

fromRows :: [[a]] -> Grid a
fromRows rows = Grid $ Map.fromDistinctAscList
  [ ((row, col), cell)
  | (row, cells) <- zip [0..] rows
  , (col, cell) <- zip [0..] cells
  ]

readGrid :: String -> Grid Char
readGrid = fromRows . readLines

cellAt :: Grid a -> Point 2 -> Maybe a
cellAt (Grid cells) (Point2D col row) = Map.lookup (row, col) cells

countNeighborsWhere :: Grid a -> Point 2 -> (a -> Bool) -> Int
countNeighborsWhere grid point predicate =
  length [() | dir <- dirs, Just cell <- [cellAt grid (step point dir)], predicate cell]

findCell :: Eq a => Grid a -> a -> Maybe (Point 2)
findCell (Grid cells) target = do
  ((row, col), _) <- find ((== target) . snd) (Map.toAscList cells)
  pure (Point2D col row)

step :: Point 2 -> Direction -> Point 2
step (Point2D col row) (dy, dx) = Point2D (col + dx) (row + dy)

movePoint :: Point 2 -> Direction -> Integer -> Integer -> Maybe (Point 2)
movePoint point direction height width
  | inBounds next height width = Just next
  | otherwise = Nothing
  where next = step point direction

raycast :: Eq a => Grid a -> Point 2 -> Direction -> a -> Maybe (Point 2)
raycast _ _ (0, 0) _ = Nothing
raycast grid start direction target = go (step start direction)
  where
    go point = do
      cell <- cellAt grid point
      if cell == target then Just point else go (step point direction)
