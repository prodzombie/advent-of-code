module Main (main) where

import qualified Day01
import System.Environment (getArgs)
import System.Exit (die)
import System.IO (readFile')
import System.IO.Error (tryIOError)

main :: IO ()
main = do
  args <- getArgs
  path <- case args of
    [] -> pure "../../../inputs/2026/day01.txt"
    [input] -> pure input
    _ -> die "Usage: aoc2026 [input-path]"
  result <- tryIOError (readFile' path)
  input <- either (die . show) pure result
  case Day01.solve input of
    Left message -> die message
    Right (part1, part2) -> do
      putStrLn ("Part 1: " ++ show part1)
      putStrLn ("Part 2: " ++ show part2)
