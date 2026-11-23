module Main (main) where

import qualified Day01
import System.Exit (die)

main :: IO ()
main =
  case Day01.solve "sample\n" of
    Left _ -> pure ()
    Right _ -> die "Day 1 should report that the solver is pending."
