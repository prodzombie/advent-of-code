module Aoc.LinAlg (gaussianElimination) where

import Data.List (partition)

-- Free variables are set to zero. Pivot values must be nonnegative integers.
gaussianElimination :: Int -> [[Integer]] -> Either String [Integer]
gaussianElimination variables matrix
  | variables < 0 = Left "Negative variable count"
  | any (\row -> length row - 1 /= variables) matrix = Left "Invalid augmented matrix dimensions"
  | otherwise = solve variables matrix

solve :: Int -> [[Integer]] -> Either String [Integer]
solve 0 rows
  | any (/= [0]) rows = Left "Inconsistent system"
  | otherwise = Right []
solve remaining rows =
  case partition zeroLeading rows of
    (zeroRows, []) -> (0 :) <$> solve (remaining - 1) (map (drop 1) zeroRows)
    (zeroRows, (pivot:coefficients):otherRows) -> do
      let eliminate (factor:rest) =
            normalize (zipWith (\a b -> pivot * a - factor * b) rest coefficients)
          eliminate [] = []
      suffix <- solve (remaining - 1) (map (drop 1) zeroRows ++ map eliminate otherRows)
      let (terms, target) = splitAt (remaining - 1) coefficients
      case target of
        [rhs] ->
          let (value, remainder) = (rhs - sum (zipWith (*) terms suffix)) `quotRem` pivot
          in if remainder == 0 && value >= 0
               then Right (value : suffix)
               else Left "Expected a nonnegative integer solution"
        _ -> Left "Invalid augmented matrix dimensions"
    (_, []:_) -> Left "Invalid augmented matrix dimensions"

zeroLeading :: [Integer] -> Bool
zeroLeading (0:_) = True
zeroLeading _ = False

normalize :: [Integer] -> [Integer]
normalize row
  | divisor > 1 = map (`quot` divisor) row
  | otherwise = row
  where divisor = foldr gcd 0 row
