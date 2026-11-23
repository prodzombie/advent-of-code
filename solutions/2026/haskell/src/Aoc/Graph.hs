module Aoc.Graph
  ( WeightedEdge(..), compareEdgesAscending, generateEdgesComplete
  , StringGraph, empty, lookupId, getId, addEdge, getNeighbors, nodeCount
  ) where

import qualified Aoc.Geometry as Geometry
import Data.List (tails)
import qualified Data.IntMap.Strict as IntMap
import qualified Data.Map.Strict as Map

data WeightedEdge = WeightedEdge { u :: !Int, v :: !Int, weight :: !Integer }
  deriving (Eq, Show)

compareEdgesAscending :: WeightedEdge -> WeightedEdge -> Ordering
compareEdgesAscending a b = compare (weight a) (weight b)

generateEdgesComplete :: [Geometry.Point3D] -> [WeightedEdge]
generateEdgesComplete points =
  [ WeightedEdge i j (Geometry.squaredDistance3D a b)
  | (i, a):rest <- tails (zip [0..] points)
  , (j, b) <- rest
  ]

-- Neighbors are stored in reverse insertion order for constant-time prepend.
data StringGraph = StringGraph !(Map.Map String Int) !(IntMap.IntMap [Int])

empty :: StringGraph
empty = StringGraph Map.empty IntMap.empty

lookupId :: String -> StringGraph -> Maybe Int
lookupId name (StringGraph names _) = Map.lookup name names

getId :: String -> StringGraph -> (Int, StringGraph)
getId name graph@(StringGraph names adj) =
  case lookupId name graph of
    Just node -> (node, graph)
    Nothing ->
      let node = nodeCount graph
      in (node, StringGraph (Map.insert name node names) (IntMap.insert node [] adj))

addEdge :: String -> String -> StringGraph -> StringGraph
addEdge from to graph =
  let (source, graph') = getId from graph
      (target, StringGraph names adj) = getId to graph'
  in StringGraph names (IntMap.adjust (target :) source adj)

getNeighbors :: Int -> StringGraph -> Maybe [Int]
getNeighbors node (StringGraph _ adj) = reverse <$> IntMap.lookup node adj

nodeCount :: StringGraph -> Int
nodeCount (StringGraph names _) = Map.size names
