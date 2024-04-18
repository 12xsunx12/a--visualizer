class_name Nod extends Node2D

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
var pos: Vector2i # eculidian position of this node
var parent: Nod # the last visited node before this one  
var g; var h; var f; # distance from start, perfect distance from end, g + h

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _init(pos: Vector2i, parent: Nod):
	self.pos = pos
	self.parent = parent
	self.g = 0
	self.h = 0
	self.f = 0

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _calculate_g() -> float:
	var a_sqrd = pow(pos.x - Global.start_pos.x, 2)
	print("a: " + str(a_sqrd))
	var b_sqrd = pow(pos.y - Global.start_pos.y, 2)
	print("b : " + str(b_sqrd))
	var c = sqrt(a_sqrd + b_sqrd)
	return c
	
# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func calculate() -> void:
	g = _calculate_g()
	print(g)
