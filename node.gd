class_name Nod extends Node2D

var pos: Vector2i # eculidian position of this node
var parent: Nod # the last visited node before this one  
var g; var h; var f; # distance from start, perfect distance from end, g + h

# constructor
func _init(pos: Vector2i, parent: Nod):
	self.pos = pos
	self.parent = parent
	self.g = 0
	self.h = 0
	self.f = 0
	_calculate()

# @param: Nod end_node
# @retur: distance
# @descr: calculates manhattan between this node and end_node
func _manhattan_distance() -> int:
	# return abs(Global.end_pos.x - self.pos.x) + abs(Global.end_pos.y - self.pos.y)
	return sqrt(pow(Global.end_pos.x - self.pos.x, 2) + pow(Global.end_pos.y - self.pos.y, 2)) * 10

# @param: none
# @retur: distance
# @descr: return the shortest travel distance from start node to this one
func _calculate_g() -> int:
	return sqrt(pow(Global.start_pos.x - self.pos.x, 2) + pow(Global.start_pos.y - self.pos.y, 2)) * 10

# @param: Nod parent, int depth
# @retur: 
# @descr: recursively backtracks from this node -> ancestors -> start node
func _calculate_g_recursive_helper(grandpa: Nod) -> int:
	var current_node = self
	var distance = 0
	
	while current_node != null and current_node.pos != Global.start_pos:
		current_node = current_node.parent
		distance += 1
	
	return distance

func _calculate_h() -> int:
	return _manhattan_distance() * 10

# @param: none
# @retur: void
# @descr: calculates g,h, and f
func _calculate() -> void:
	g = _calculate_g()
	h = _calculate_h()
	f = g + h
