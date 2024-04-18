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
var pri_que: Array 						# the priority que
var path: Array = [] 									# the constructed shortest path
var max_evaluations = 500 								# if astar can't find end in 5000 searches, throw error

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _process(delta):
	if Input.is_action_just_pressed("press_e"):
		pri_que.clear()
		path.clear()
		start_node.pos = Global.start_pos 		# node where A* begins
		end_node.pos = Global.end_pos 			# the goal node
		pri_que = [start_node]
		astar()
		_draw()

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _get_adj_nodes(node: Nod) -> void:
	var node_pos = node.pos	
	
	# create nodes
	var node_right = Nod.new(Vector2i(node_pos.x + 1, node_pos.y), node); var right_exist = false;
	var node_left = Nod.new(Vector2i(node_pos.x - 1, node_pos.y), node); var left_exist = false;
	var node_up = Nod.new(Vector2i(node_pos.x, node_pos.y - 1), node); var up_exist = false;
	var node_down = Nod.new(Vector2i(node_pos.x, node_pos.y + 1), node); var down_exist = false;
	
	# see if nodes have already been visited
	for vis_node in path:
		if node_down.pos == vis_node.pos:
			down_exist = true
		if node_up.pos == vis_node.pos:
			up_exist = true
		if node_left.pos == vis_node.pos:
			left_exist = true
		if node_right.pos == vis_node.pos:
			right_exist = true

	# add nodes to que
	if !down_exist:
		pri_que.push_front(node_down)
	if !up_exist:
		pri_que.push_front(node_up)
	if !left_exist:
		pri_que.push_front(node_left)
	if !right_exist:
		pri_que.push_front(node_right)

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _return_lowest_f_in_que() -> int:
	if !pri_que.is_empty():
		var lowest_f = pri_que[0].f
		var index = 0
		var i = 0
		for node in pri_que:
			if node.f < lowest_f:
				lowest_f = node.f
				index = i
			i += 1
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
func _draw_path():
	for node in path:
		draw_rect(Rect2(node.pos * Global.cell_size, Global.cell_size), Color.YELLOW)
	queue_redraw()

# // - - - - - - - - - - - - - - - - - - - - - - - - -
func _draw():
	_draw_path()

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func astar() -> void:
	var counter = 0
	path.push_front(start_node)
	while pri_que: # for every node in the que
		curr_node = pri_que.pop_front() # obtain first node in que and remove
		
		if curr_node.pos == end_node.pos: # if obtained node is the end node, return
			pri_que.clear() # clean the array of left over nodes
			return
		elif counter >= max_evaluations:
			pri_que.clear()
			print("\n\n~ - ~ Error ~ - ~\n" + "max evals exceeded, could not find end after " + str(max_evaluations) + " searches")
			break
		else:
			curr_node.calculate() # calculate g, h, & f
			_get_adj_nodes(curr_node) # explore adjacent nodes
			_place_lowest_f_at_front() # find lowest f node, and place at front of que
			path.append(pri_que.front()) # append the chosen node
			# debug_print_f()
			counter += 1

# // - - - - - - - - - - - - - - - - - - - - - - - - -
func print_path():
	for node in path:
		print(str(node.pos))

# // - - - - - - - - - - - - - - - - - - - - - - - - -
func debug_print_f():
	for node in pri_que:
		print("Node Pos: \t" + str(node.pos) + " \t Node f: \t" + str(node.f))
	print(pri_que[_return_lowest_f_in_que()].pos)
	print("\n")
