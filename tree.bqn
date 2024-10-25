#!/usr/bin/env BQN

##### Tree Wrangling idioms in BQN #####
# Following the guide at
# https://asherbhs.github.io/apl-site/trees/parent-vectors.html

parent←⟨0,0,1,2,2,1,0,6,7,7,7,0⟩

##### Finding children #####
p←parent

# Children of nodes 'i' are all nodes
# whose parent is in 'i'.
# =: Works for a single index
# ∊: Works for an array of indices
i←1‿6
p∊i

# 'Indices' gives the nodes chosen
# by the above mask
•Show /p∊i

##### Finding leaves #####
p←parent

# Node IDs (indices)
↕p

# Leaf nodes are those nodes which
# do not have any children.
# i.e. those nodes which do not
# exist in the parent array
•Show ↕p
