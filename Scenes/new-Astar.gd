extends Node2D

# the node we're starting at
var start_node = Nod.new(Global.start_pos, null)

# the goal node we wish to map the shortest path too
var end_node = Nod.new(Global.end_pos, null)

# the conclusive shortest path to our goal node
var path: Array = []

func _process(delta):
	if Input.is_action_just_pressed("press_e"):
		main()

# main method
func main():
	print("Start Node: " + str(start_node.pos))
	print("End Node: " + str(end_node.pos))
	Global.candidate_nodes.append(start_node)
	for node in a_star():
		print(node.pos)
	_draw()

# Draw the path with yellow squares
func _draw_path():
	for node in path:
		draw_rect(Rect2(node.pos * Global.cell_size, Global.cell_size), Color.YELLOW)
	queue_redraw()

func _already_visited(current_node: Vector2i) -> bool:
	for node in path:
		if current_node == node.pos:
			return false
	return true

# @param: Nod node
# @retur: array of nearby nodes
# @descr: takes a node as input and returns adjacent nodes (neighbors)
func _get_neighbors(node: Nod) -> Array:
	var neighbors: Array = []
	if !Global.grid.is_point_solid(Vector2i(node.pos.x + 1, node.pos.y)) and _already_visited(Vector2i(node.pos.x + 1, node.pos.y)):
		neighbors.append(Nod.new(Vector2i(node.pos.x + 1, node.pos.y), node)) # node to the right
	if !Global.grid.is_point_solid(Vector2i(node.pos.x - 1, node.pos.y)) and _already_visited(Vector2i(node.pos.x - 1, node.pos.y)):
		neighbors.append(Nod.new(Vector2i(node.pos.x - 1, node.pos.y), node)) # node to the left
	if !Global.grid.is_point_solid(Vector2i(node.pos.x, node.pos.y + 1)) and _already_visited(Vector2i(node.pos.x, node.pos.y + 1)):
		neighbors.append(Nod.new(Vector2i(node.pos.x, node.pos.y + 1), node)) # node up
	if !Global.grid.is_point_solid(Vector2i(node.pos.x, node.pos.y - 1)) and _already_visited(Vector2i(node.pos.x, node.pos.y - 1)):
		neighbors.append(Nod.new(Vector2i(node.pos.x, node.pos.y - 1), node)) # node down
	return neighbors

# @param: Array array_to_clean
# @retur: cleaned array
# @descr: scrubs an array of duplicate values
func _remove_duplicates(array_to_clean: Array) -> Array:
	var unique_array = []
	var unique_values = {}

	for element in array_to_clean:
		if !unique_values.has(element):
			unique_values[element] = true
			unique_array.append(element)

	return unique_array

# @param: Array nodes
# @retur: node with lowest f value
# @descr: this function compares an array of nodes and returns...
# the node with the lowest f value
func _compare_f(nodes: Array) -> Nod:
	var min = nodes[0].f
	var i = 0
	var index = 0
	for node in nodes:
		if node.f < min:
			index = i
			min = node.f
		i += 1
	return nodes[index]

# @param: none
# @retur: Array path
# @descr: computes the shortest-path-traversable between two nodes
func a_star() -> Array:
	while Global.candidate_nodes:
		# grab the front most node from the queue
		var current_node = Global.candidate_nodes.pop_front()

		# if current is end, stop and return the path
		if current_node.pos == Global.end_pos:
			return path

		# assess all of it's neighbors
		var neighbors = _get_neighbors(current_node)

		# determine which neighbor has the lowest f value
		var winning_node = _compare_f(neighbors)
		for n in neighbors:
			print("Neighbors: " + str(n.pos) + "\t\t\tg: " + str(n.g) + "\th: " + str(n.h) + "\tf: " + str(n.f))
		print()

		# add neighbors to front of queue, winning node goes at the very front
		Global.candidate_nodes.append_array(neighbors)
		Global.candidate_nodes.push_front(winning_node)

		# remove all duplicate nodes from the candidates, can't find a way not to add duplicates ://
		Global.candidate_nodes = _remove_duplicates(Global.candidate_nodes)

		# collect the winning nodes into an array
		path.append(winning_node)
		_draw()
	return []

func _draw():
	_draw_path()
