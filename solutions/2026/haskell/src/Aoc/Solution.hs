module Aoc.Solution
  ( Solver
  , DaySolution(..)
  , solveDay
  , Metrics(..)
  , totalTimeMs
  , measureMetrics
  ) where

import Control.Exception (evaluate)
import GHC.Clock (getMonotonicTimeNSec)

type Solver = String -> Either String Integer

data DaySolution = DaySolution
  { solvePart1 :: Solver
  , solvePart2 :: Solver
  }

-- | Run both parts against the same input, returning the first error.
solveDay :: DaySolution -> String -> Either String (Integer, Integer)
solveDay solution input =
  (,) <$> solvePart1 solution input <*> solvePart2 solution input

data Metrics = Metrics
  { part1Result :: !Integer
  , part1TimeMs :: !Double
  , part2Result :: !Integer
  , part2TimeMs :: !Double
  } deriving (Eq, Show)

totalTimeMs :: Metrics -> Double
totalTimeMs metrics = part1TimeMs metrics + part2TimeMs metrics

measureMetrics :: DaySolution -> String -> IO (Either String Metrics)
measureMetrics solution input = do
  first <- measure (solvePart1 solution) input
  case first of
    Left message -> pure (Left message)
    Right (answer1, time1) -> do
      second <- measure (solvePart2 solution) input
      pure $ do
        (answer2, time2) <- second
        pure Metrics
          { part1Result = answer1
          , part1TimeMs = time1
          , part2Result = answer2
          , part2TimeMs = time2
          }

measure :: Solver -> String -> IO (Either String (Integer, Double))
measure solver input = do
  start <- getMonotonicTimeNSec
  case solver input of
    Left message -> pure (Left message)
    Right result -> do
      answer <- evaluate result
      end <- getMonotonicTimeNSec
      pure (Right (answer, fromIntegral (end - start) / 1e6))
