extends Node2D
	
func manhattan_distance(current, end):
	return abs(Global.end_node.x - current.x + Global.end_node.y - current.y)
	
func get_neighbors(node: Vector2i):
	var x = node.x
	var y = node.y
	
	var neighbors = [
		Vector2i(x+1, y), # node to the right
		Vector2i(x-1, y), # node to the left
		Vector2i(x, y+1), # node to the up
		Vector2i(x, y-1)  # node to the down
	]
	
	return neighbors
	
func sort_by_f(current_node, neighbor_node):
	return current_node["f"] - neighbor_node["f"]
	
func draw_current_node():
	for nodes in Global.nodes_to_draw:
		draw_rect(Rect2(nodes["pos"] * Global.cell_size, Global.cell_size), Color.YELLOW)
			
func a_star():
	var current = Global.candidate_nodes[0]
	Global.nodes_to_draw.append(current)
	queue_redraw()
	Global.candidate_nodes.remove_at(0)
	for node in Global.candidate_nodes:
		print(node["pos"])
	var current_pos = current["pos"]

	if current_pos == Global.end_node:
		while current != null:
			Global.path.insert(0, current["pos"])
			current = current["parent"]
		return Global.path
	
	Global.visited_nodes.append(current_pos)

	for neighbor_pos in get_neighbors(current_pos):
		if neighbor_pos in Global.visited_nodes:
			continue
		
		var g = current["g"] + 1
		var h = manhattan_distance(neighbor_pos, Global.end_node)
		var f = g + h
		
		var neighbor = {
			"pos": neighbor_pos,
			"g": g,
			"h": h,
			"f": f,
			"parent": current
		}
	
		Global.candidate_nodes.append(neighbor)
	
	return null # no path found
	
func _draw():
	draw_current_node()
