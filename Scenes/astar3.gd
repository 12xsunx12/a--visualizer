extends Node2D

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
var start_node: Vector2i = Global.start_pos 	# node where A* begins
var end_node: Vector2i = Global.end_pos 		# the goal node
var pri_que: Array = [] 						# the priority que
var path: Array = [] 							# the constructed shortest path
