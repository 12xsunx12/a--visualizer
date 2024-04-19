extends Node2D

var p: priQ = priQ.new()
var node1: Nod = Nod.new(Vector2i(0,0), null)
var node2: Nod = Nod.new(Vector2i(5,0), null)
var node3: Nod = Nod.new(Vector2i(-3,0), null)

# Called when the node enters the scene tree for the first time.
func _ready():
	test()

func test():
	p.enqueue(node1)
	p.enqueue(node2)
	p.enqueue(node3)
	print(p.dequeue().pos)
	
	
