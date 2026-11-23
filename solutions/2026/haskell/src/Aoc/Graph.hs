{-# LANGUAGE DataKinds #-}

module Aoc.Graph (
    WeightedEdge (..),
    compareEdgesAscending,
    generateEdgesComplete,
    Graph,
    empty,
    addNode,
    addEdge,
    fromEdges,
    neighbors,
    nodeCount,
) where

import qualified Aoc.Geometry as Geometry
import qualified Data.List as List
import qualified Data.Map.Strict as Map

data WeightedEdge = WeightedEdge {u :: !Int, v :: !Int, weight :: !Integer}
    deriving (Eq, Show)

compareEdgesAscending :: WeightedEdge -> WeightedEdge -> Ordering
compareEdgesAscending a b = compare (weight a) (weight b)

generateEdgesComplete :: [Geometry.Point 3] -> [WeightedEdge]
generateEdgesComplete points =
    [ WeightedEdge i j (Geometry.squaredDistance a b)
    | (i, a) : rest <- List.tails (zip [0 ..] points)
    , (j, b) <- rest
    ]

-- Store outgoing edges in reverse insertion order for cheap prepending.
newtype Graph node = Graph (Map.Map node [node])

empty :: Graph node
empty = Graph Map.empty

addNode :: (Ord node) => node -> Graph node -> Graph node
addNode node (Graph adjacency) =
    Graph (Map.insertWith (\_ existing -> existing) node [] adjacency)

addEdge :: (Ord node) => node -> node -> Graph node -> Graph node
addEdge from to graph =
    let Graph adjacency = addNode to graph
     in Graph (Map.insertWith (++) from [to] adjacency)

fromEdges :: (Ord node) => [(node, node)] -> Graph node
fromEdges = List.foldl' (\graph (from, to) -> addEdge from to graph) empty

neighbors :: (Ord node) => node -> Graph node -> Maybe [node]
neighbors node (Graph adjacency) = reverse <$> Map.lookup node adjacency

nodeCount :: Graph node -> Int
nodeCount (Graph adjacency) = Map.size adjacency
