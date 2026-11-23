module Aoc.Parse
  ( parseNatural, parseRange, parseRangeStart, parseRangeStop, extractDigits
  , parseIntWithPrefix, tokenizeToList, trimLine, readLines
  ) where

import Data.Char (digitToInt, isDigit)
import Data.List (dropWhileEnd)
import Numeric.Natural (Natural)
import Text.Read (readMaybe)

parseRange :: String -> Either String (Natural, Natural)
parseRange input =
  case break (== '-') input of
    (start, '-':stop) -> (,) <$> parseNatural start <*> parseNatural stop
    _ -> Left ("Expected start-stop: " ++ show input)

parseRangeStart :: String -> Either String Natural
parseRangeStart = fmap fst . parseRange

parseRangeStop :: String -> Either String Natural
parseRangeStop = fmap snd . parseRange

extractDigits :: Natural -> [Int]
extractDigits = map digitToInt . show

parseIntWithPrefix :: String -> Char -> Char -> Either String Integer
parseIntWithPrefix (prefix:digits) positive negative
  | prefix == positive = toInteger <$> parseNatural digits
  | prefix == negative = negate . toInteger <$> parseNatural digits
parseIntWithPrefix input _ _ = Left ("Invalid prefixed integer: " ++ show input)

-- | Parse a nonempty sequence of ASCII decimal digits.
parseNatural :: String -> Either String Natural
parseNatural s
  | all isDigit s, Just n <- readMaybe s = Right n
  | otherwise = Left ("Expected unsigned decimal: " ++ show s)

tokenizeToList :: Char -> String -> [String]
tokenizeToList delimiter = go
  where
    isDelimiter = (== delimiter)
    go input =
      case break isDelimiter (dropWhile isDelimiter input) of
        ([], _) -> []
        (token, rest) -> token : go rest

trimLine :: String -> String
trimLine = dropWhileEnd whitespace . dropWhile whitespace
  where whitespace c = c `elem` " \t\r\n"

readLines :: String -> [String]
readLines = filter (not . null) . map trimLine . lines
