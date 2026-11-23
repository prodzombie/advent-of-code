module Aoc.Grid
  ( Grid, Direction, dirs, inBounds, readGrid, countNeighborsWhere
  , findCell, movePoint, raycast
  ) where

import Aoc.Geometry (Point(..))
import Aoc.Parse (readLines)
import Data.List (find)
import qualified Data.Map.Strict as Map

type Direction = (Integer, Integer) -- (dy, dx)
type Grid = Map.Map (Integer, Integer) Char -- (row, column)

dirs :: [Direction]
dirs = [(dy, dx) | dy <- [-1..1], dx <- [-1..1], (dy, dx) /= (0, 0)]

inBounds :: Point -> Integer -> Integer -> Bool
inBounds (Point col row) height width =
  0 <= row && row < height && 0 <= col && col < width

readGrid :: String -> Grid
readGrid input = Map.fromDistinctAscList
  [ ((row, col), cell)
  | (row, cells) <- zip [0..] (readLines input)
  , (col, cell) <- zip [0..] cells
  ]

at :: Grid -> Point -> Maybe Char
at grid (Point col row) = Map.lookup (row, col) grid

countNeighborsWhere :: Grid -> Point -> (Char -> Bool) -> Int
countNeighborsWhere grid point predicate =
  length [() | dir <- dirs, Just cell <- [at grid (step point dir)], predicate cell]

findCell :: Grid -> Char -> Maybe Point
findCell grid target = do
  ((row, col), _) <- find ((== target) . snd) (Map.toAscList grid)
  pure (Point col row)

step :: Point -> Direction -> Point
step (Point col row) (dy, dx) = Point (col + dx) (row + dy)

movePoint :: Point -> Direction -> Integer -> Integer -> Maybe Point
movePoint point direction height width
  | inBounds next height width = Just next
  | otherwise = Nothing
  where next = step point direction

raycast :: Grid -> Point -> Direction -> Char -> Maybe Point
raycast _ _ (0, 0) _ = Nothing
raycast grid start direction target = go (step start direction)
  where
    go point = do
      cell <- at grid point
      if cell == target then Just point else go (step point direction)
