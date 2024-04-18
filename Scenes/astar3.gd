extends Node2D

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
# How A* Works Via Steps:
# 1.) pop the start node off the que, and evaluate it's neighbors and add them to the que
# 2.) evaluate the f value on each node in the que
# 3.) the lowest f value is popped from the que
# 4.) popped node is evaluated for neighbor nodes, repeat from step 1

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
var start_node: Nod = Nod.new(Global.start_pos, null) 	# node where A* begins
var end_node: Nod = Nod.new(Global.end_pos, null) 		# the goal node
var curr_node: Nod = null 								# popped node being evald
var pri_que: Array = [start_node] 						# the priority que
var path: Array = [] 									# the constructed shortest path

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _ready():
	astar()

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func astar() -> void:
	curr_node = pri_que.pop_front()
	print("Current Node: " + str(curr_node.pos))
	curr_node.calculate()
