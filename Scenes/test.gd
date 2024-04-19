extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	test()

func test():
	var dic: Dictionary = {}
	var cord0: Vector2i = Vector2i(5,5)
	var cord1: Vector2i = Vector2i(10,10)
	var cord2: Vector2i = Vector2i(15,15)
	var node0: Nod = Nod.new(cord0, null)
	var node1: Nod = Nod.new(cord1, null)
	var node2: Nod = Nod.new(cord2, null)
	
	dic[cord0] = node0
	dic[cord1] = node1
	dic[cord2] = node2
	
	for key in dic:
		print(dic[key].pos)
	
	
