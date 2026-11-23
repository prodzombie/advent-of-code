module Aoc.Solution (Solver, DaySolution(..), Metrics(..), totalTimeMs, measureMetrics) where

import Control.Exception (evaluate)
import GHC.Clock (getMonotonicTimeNSec)

type Solver = String -> Either String Integer

data DaySolution = DaySolution
  { solvePart1 :: Solver
  , solvePart2 :: Solver
  }

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
      pure (fmap (\(answer2, time2) -> Metrics answer1 time1 answer2 time2) second)

measure :: Solver -> String -> IO (Either String (Integer, Double))
measure solver input = do
  start <- getMonotonicTimeNSec
  case solver input of
    Left message -> pure (Left message)
    Right result -> do
      answer <- evaluate result
      end <- getMonotonicTimeNSec
      pure (Right (answer, fromIntegral (end - start) / 1e6))
