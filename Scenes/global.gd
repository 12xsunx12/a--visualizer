extends Node2D

var start_pos 	= Vector2i(5,5)
var end_pos 	= Vector2i(100,5)
var cell_size 	= Vector2i(10,10) # the size of the actual boxes in the grid
var grid = AStarGrid2D.new()
var time: float = 0.016
