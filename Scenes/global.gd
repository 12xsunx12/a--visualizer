extends Node2D

var start_pos 	= Vector2i(5,5)
var end_pos 	= Vector2i(8,6)
var cell_size 	= Vector2i(15,15) # the size of the actual boxes in the grid
var grid = AStarGrid2D.new() # the grid object itself

# any nodes that are candidates to the shortest path
var candidate_nodes = []

var path = []
