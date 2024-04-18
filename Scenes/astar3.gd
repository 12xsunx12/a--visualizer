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
var max_evaluations = 500 								# if astar can't find end in 5000 searches, throw error

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _ready():
	astar()

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _get_adj_nodes_simple(node: Nod) -> void:
	var node_pos = node.pos	
	var node_right = Nod.new(Vector2i(node_pos.x + 1, node_pos.y), node); node_right.calculate();
	var node_left = Nod.new(Vector2i(node_pos.x - 1, node_pos.y), node); # node_left.calculate();
	var node_up = Nod.new(Vector2i(node_pos.x, node_pos.y - 1), node); node_up.calculate();
	var node_down = Nod.new(Vector2i(node_pos.x, node_pos.y + 1), node); node_down.calculate();
	pri_que.push_front(node_down)
	pri_que.push_front(node_up)
	pri_que.push_front(node_left)
	pri_que.push_front(node_right)
	
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
		print("\n\n~ - ~ Error ~ - ~\n_return_lowest_f_in_que: que is empty / null")
		return 0

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _place_lowest_f_at_front() -> void:
	var index = _return_lowest_f_in_que()
	var node: Nod = pri_que.pop_at(index)
	pri_que.push_front(node)

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func astar() -> void:
	var counter = 0
	while pri_que: # for every node in the que
		curr_node = pri_que.pop_front() # obtain first node in que and remove
		
		if curr_node.pos == end_node.pos: # if obtained node is the end node, return
			pri_que.clear() # clean the array of left over nodes
			return
		elif counter >= max_evaluations:
			print("\n\n~ - ~ Error ~ - ~\n" + "max evals exceeded, could not find end after " + str(max_evaluations) + " searches")
			break
		else:
			curr_node.calculate() # calculate g, h, & f
			_get_adj_nodes_simple(curr_node) # explore adjacent nodes
			_place_lowest_f_at_front() # find lowest f node, and place at front of que
			counter += 1
