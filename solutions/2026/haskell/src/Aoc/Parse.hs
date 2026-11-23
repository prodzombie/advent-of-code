module Aoc.Parse
  ( parseRange, parseRangeStart, parseRangeStop, extractDigits
  , parseIntWithPrefix, tokenizeToList, trimLine, readLines
  ) where

import Data.Char (digitToInt, isDigit)
import Data.List (dropWhileEnd)
import Numeric.Natural (Natural)
import Text.Read (readMaybe)

parseRange :: String -> Either String (Natural, Natural)
parseRange input =
  case break (== '-') input of
    (start, '-':stop) -> (,) <$> decimal start <*> decimal stop
    _ -> Left ("Expected start-stop: " ++ show input)

parseRangeStart :: String -> Either String Natural
parseRangeStart = fmap fst . parseRange

parseRangeStop :: String -> Either String Natural
parseRangeStop = fmap snd . parseRange

extractDigits :: Natural -> [Int]
extractDigits = map digitToInt . show

parseIntWithPrefix :: String -> Char -> Char -> Either String Integer
parseIntWithPrefix (prefix:digits) positive negative
  | prefix == positive = toInteger <$> decimal digits
  | prefix == negative = negate . toInteger <$> decimal digits
parseIntWithPrefix input _ _ = Left ("Invalid prefixed integer: " ++ show input)

decimal :: String -> Either String Natural
decimal s
  | all isDigit s, Just n <- readMaybe s = Right n
  | otherwise = Left ("Expected unsigned decimal: " ++ show s)

tokenizeToList :: Char -> String -> [String]
tokenizeToList delimiter input =
  case break (== delimiter) (dropWhile (== delimiter) input) of
    ([], _) -> []
    (token, rest) -> token : tokenizeToList delimiter rest

trimLine :: String -> String
trimLine = dropWhileEnd whitespace . dropWhile whitespace
  where whitespace c = c `elem` " \t\r\n"

readLines :: String -> [String]
readLines = filter (not . null) . map trimLine . lines
