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
var pri_que: priQ = priQ.new()				# the priority que
var path: Dictionary = {} 								# the constructed shortest path
var max_evaluations = 15000 							# if astar can't find end in 5000 searches, throw error
var max_que_size = 50
@export var timer: Timer
var counter: int = 0

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _process(delta):
	if Input.is_action_just_pressed("press_a"):
		pri_que.clear()
		path.clear()
		start_node.pos = Global.start_pos 		# node where A* begins
		end_node.pos = Global.end_pos 			# the goal node
		path[start_node.pos] = start_node
		pri_que.set_start(start_node)
		timer.start(Global.time)
		astar()
	queue_redraw()

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
		pri_que.enqueue(node_down)
	if !up_exist:
		pri_que.enqueue(node_up)
	if !left_exist:
		pri_que.enqueue(node_left)
	if !right_exist:
		pri_que.enqueue(node_right)
	
# // - - - - - - - - - - - - - - - - - - - - - - - - -
func _draw_que():
	for node in pri_que.get_elements():
		draw_rect(Rect2(node["item"].pos * Global.cell_size, Global.cell_size), Color.DARK_TURQUOISE)
	
# // - - - - - - - - - - - - - - - - - - - - - - - - -
func _draw_path():
	for key in path:
		draw_rect(Rect2(path[key].pos * Global.cell_size, Global.cell_size), Color.PINK)

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
	
	if pri_que.size() > max_que_size:
		pri_que.clear()
		pri_que.set_start(curr_node)
		
	curr_node = pri_que.dequeue() # obtain first node in que and remove
	path[curr_node.pos] = curr_node
	_get_adj_nodes(curr_node) # explore adjacent nodes
	# debug_print_f()
	counter += 1

# // - - - - - - - - - - - - - - - - - - - - - - - - -
func print_path():
	for node in path:
		print(str(node.pos))
