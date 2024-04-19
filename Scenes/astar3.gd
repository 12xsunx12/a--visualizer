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
var curr_node: Nod = start_node 						# popped node being evald
var pri_que: Array 										# the priority que
var path: Dictionary = {} 									# the constructed shortest path
var max_evaluations = 15000 							# if astar can't find end in 5000 searches, throw error
@export var timer: Timer
var counter: int = 0

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _process(delta):
	if Input.is_action_just_pressed("press_a"):
		pri_que.clear()
		path.clear()
		start_node.pos = Global.start_pos 		# node where A* begins
		end_node.pos = Global.end_pos 			# the goal node
		pri_que = [start_node]
		path[start_node.pos] = start_node
		timer.start(Global.time)
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
	if path.has(node_down.pos):
		down_exist = true
	if path.has(node_up.pos):
		up_exist = true
	if path.has(node_left.pos):
		left_exist = true
	if path.has(node_right.pos):
		right_exist = true

	# see if nodes are a wall
	if Global.grid.is_point_solid(node_right.pos):
		right_exist = true
	if Global.grid.is_point_solid(node_left.pos):
		left_exist = true
	if Global.grid.is_point_solid(node_down.pos):
		down_exist = true
	if Global.grid.is_point_solid(node_up.pos):
		up_exist = true

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
		var lowest_f_index = 0
		var lowest_f = pri_que[0].f
		
		# Find the index of the element with the lowest f value
		for i in range(1, pri_que.size()):
			if pri_que[i].f < lowest_f:
				lowest_f = pri_que[i].f
				lowest_f_index = i
		
		return lowest_f_index
	else:
		print("\n\n~ - ~ Error ~ - ~\n_return_lowest_f_in_que: que is empty / null")
		return 0

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _place_lowest_f_at_front() -> void:
	var index = _return_lowest_f_in_que()
	var node: Nod = pri_que.pop_at(index)
	pri_que.push_front(node)
	
# // - - - - - - - - - - - - - - - - - - - - - - - - -
func _draw_que():
	for node in pri_que:
		draw_rect(Rect2(node.pos * Global.cell_size, Global.cell_size), Color.DARK_TURQUOISE)
	queue_redraw()
	
# // - - - - - - - - - - - - - - - - - - - - - - - - -
func _draw_path():
	for key in path:
		draw_rect(Rect2(path[key].pos * Global.cell_size, Global.cell_size), Color.BLUE_VIOLET)
	queue_redraw()

# // - - - - - - - - - - - - - - - - - - - - - - - - -
func _draw():
	_draw_que()
	_draw_path()

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func astar() -> void:
	if counter >= max_evaluations:
		pri_que.clear()
		print("\n\n~ - ~ Error ~ - ~\n" + "max evals exceeded, could not find end after " + str(max_evaluations) + " searches")
		return
		
	if curr_node.pos == end_node.pos: # if obtained node is the end node, return
		pri_que.clear() # clean the array of left over nodes
		return
		
	curr_node = pri_que.pop_front() # obtain first node in que and remove
	curr_node.calculate() # calculate g, h, & f
	_get_adj_nodes(curr_node) # explore adjacent nodes
	_place_lowest_f_at_front() # find lowest f node, and place at front of que
	path[pri_que.front().pos] = pri_que.front()
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
