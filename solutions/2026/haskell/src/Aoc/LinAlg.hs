module Aoc.LinAlg (gaussianElimination) where

import qualified Data.List as List

-- Keep the target separate as coefficient columns are eliminated.
data Equation = Equation [Integer] Integer

-- Free variables are set to zero. Pivot values must be nonnegative integers.
gaussianElimination :: Int -> [[Integer]] -> Either String [Integer]
gaussianElimination variables matrix
  | variables < 0 = Left "Negative variable count"
  | otherwise = traverse toEquation matrix >>= solve variables
  where
    toEquation row = case splitAt variables row of
      (coefficients, [target]) -> Right (Equation coefficients target)
      _ -> Left "Invalid augmented matrix dimensions"

solve :: Int -> [Equation] -> Either String [Integer]
solve remaining equations
  | any (/= 0) constantRows = Left "Inconsistent system"
  | remaining == 0 = Right []
  | otherwise =
      case break (\(factor, _) -> factor /= 0) leadingRows of
        (zeros, []) -> (0 :) <$> solve (remaining - 1) (map snd zeros)
        (zeros, (pivot, equation):rest) -> do
          suffix <- solve (remaining - 1) (map snd zeros ++ map (eliminate pivot equation) rest)
          value <- backSubstitute pivot equation suffix
          pure (value : suffix)
  where
    constantRows = [target | Equation [] target <- equations]
    leadingRows = [(factor, Equation terms target) | Equation (factor:terms) target <- equations]

eliminate :: Integer -> Equation -> (Integer, Equation) -> Equation
eliminate _ _ (0, equation) = equation
eliminate pivot (Equation terms target) (factor, Equation otherTerms otherTarget) =
  let coefficients = zipWith subtractPivot otherTerms terms
      rhs = subtractPivot otherTarget target
      divisor = List.foldl' gcd (abs rhs) coefficients
  in if divisor > 1
       then Equation (map (`quot` divisor) coefficients) (rhs `quot` divisor)
       else Equation coefficients rhs
  where
    subtractPivot a b = pivot * a - factor * b

backSubstitute :: Integer -> Equation -> [Integer] -> Either String Integer
backSubstitute pivot (Equation terms target) suffix =
  let (value, remainder) = (target - sum (zipWith (*) terms suffix)) `quotRem` pivot
  in if remainder == 0 && value >= 0
       then Right value
       else Left "Expected a nonnegative integer solution"
