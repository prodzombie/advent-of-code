module Aoc.Geometry (Point(..), Point3D(..), Edge(..), euclideanDistance3DSq) where

data Point = Point { x :: !Integer, y :: !Integer }
  deriving (Eq, Ord, Show)

data Point3D = Point3D !Integer !Integer !Integer
  deriving (Eq, Ord, Show)

data Edge = Edge { p1 :: !Point, p2 :: !Point }
  deriving (Eq, Ord, Show)

euclideanDistance3DSq :: Point3D -> Point3D -> Integer
euclideanDistance3DSq (Point3D ax ay az) (Point3D bx by bz) =
  square (bx - ax) + square (by - ay) + square (bz - az)
  where square n = n * n
