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
/p∊i

##### Finding leaves #####
#p←parent

# Node IDs (indices)
↕≠p

# Leaf nodes are those nodes which
# do not have any children.
# i.e. those nodes which do not
# exist in the parent array
(/·¬↕∘≠∊⊢)p

##### Trimming branches #####
# To trim a node from its parent,
# set its parent to itself.

6⌾(6⊸⊑)⊸≍ p

##### Finding roots ######
# To find the roots of all trees in the parent vector, we
# repeatedly index with the parent vector to a fixed point.

# Given (p F prev‿cur), index up one in the parent vector
F←(⊏⋈⊢)⟜⊑

# Keep iterating until prev≡cur
p F•_while_(≢´⊢) p F p‿p

##### Finding subtrees #####

# To select subtrees for node n, do the same as above
# except *don't* index upwards for any n in p
n←7
>(↕≠p)‿p‿((p⊐n) n⊸=◶⊢‿⊣¨ p)

##### Shuffling #####

# To FIX a parent vector after it has been shuffled by
# some permutation perm, find the index of where each parent
# was sent by perm.
perm←⟨8,3,10,11,7,6,5,4,9,2,0,1⟩
(↕≠p)‿p‿(perm⊏p)‿(perm (⊣⊐⊏) p)

##### Mirroring the Tree #####
# To reverse the order of siblings in the tree (i.e. mirroring),
# just reverse the parent vector and "invert" all parent values
# to FIX the parent vector

•Show > (↕≠p)‿p‿(⌽p)‿((¯1+≠-⌽)p)
