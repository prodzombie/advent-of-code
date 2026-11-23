module Aoc.Geometry (
    Point2D (..),
    Point3D (..),
    Segment (..),
    squaredDistance2D,
    squaredDistance3D,
) where

data Point2D = Point2D {x :: !Integer, y :: !Integer}
    deriving (Eq, Ord, Show)

data Point3D = Point3D !Integer !Integer !Integer
    deriving (Eq, Ord, Show)

data Segment = Segment {segmentStart :: !Point2D, segmentEnd :: !Point2D}
    deriving (Eq, Ord, Show)

squaredDistance2D :: Point2D -> Point2D -> Integer
squaredDistance2D (Point2D ax ay) (Point2D bx by) =
    square (bx - ax) + square (by - ay)

squaredDistance3D :: Point3D -> Point3D -> Integer
squaredDistance3D (Point3D ax ay az) (Point3D bx by bz) =
    square (bx - ax) + square (by - ay) + square (bz - az)

square :: Integer -> Integer
square n = n * n
