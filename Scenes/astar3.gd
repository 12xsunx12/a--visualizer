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
func _get_adj_nodes_simple(node: Nod) -> void:
	var node_pos = node.pos
	var neighbors: Array = []
	
	pri_que.push_front(Nod.new(Vector2i(node_pos.x + 1, node_pos.y), node)) 	# node to right
	pri_que.push_front(Nod.new(Vector2i(node_pos.x - 1, node_pos.y), node)) 	# node to left
	pri_que.push_front(Nod.new(Vector2i(node_pos.x, node_pos.y - 1), node)) 	# node to up
	pri_que.push_front(Nod.new(Vector2i(node_pos.x, node_pos.y + 1), node)) 	# node to down
	
# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _return_lowest_f_in_que() -> int:
	if !pri_que.is_empty():
		var lowest_f = pri_que[0].f
		var index = 0
		var i = 0
		for node in pri_que:
			i += 1
			if node.f < lowest_f:
				lowest_f = node.f
				index = i
		return index
	else:
		print("~ - ~ Error ~ - ~\n_return_lowest_f_in_que: que is empty / null")
		return 0

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func astar() -> void:
	while pri_que:
		curr_node = pri_que.pop_front()
		curr_node.calculate()
		_get_adj_nodes_simple(curr_node)
		print("Current Node: \t" + str(curr_node.pos))
		print("Que:")
		for node in pri_que:
			print(str(node.pos))
		print("Lowest F Index: \t" + str(_return_lowest_f_in_que()))
		print("Lowest F Pos: \t" + str(pri_que[_return_lowest_f_in_que()].pos))
		break
