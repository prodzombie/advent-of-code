{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE StandaloneDeriving #-}

module Aoc.Geometry (
    Point (..),
    Segment (..),
    squaredDistance,
) where

import GHC.TypeNats (Nat)

-- The dimension index ensures that distance compares points of the same dimension.
data Point (n :: Nat) where
    Point2D :: {x :: !Integer, y :: !Integer} -> Point 2
    Point3D :: !Integer -> !Integer -> !Integer -> Point 3

deriving instance Eq (Point n)
deriving instance Ord (Point n)
deriving instance Show (Point n)

data Segment = Segment {segmentStart :: !(Point 2), segmentEnd :: !(Point 2)}
    deriving (Eq, Ord, Show)

squaredDistance :: Point n -> Point n -> Integer
squaredDistance (Point2D ax ay) (Point2D bx by) =
    square (bx - ax) + square (by - ay)
squaredDistance (Point3D ax ay az) (Point3D bx by bz) =
    square (bx - ax) + square (by - ay) + square (bz - az)

square :: Integer -> Integer
square n = n * n
