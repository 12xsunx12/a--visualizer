extends Node2D

var cell_size = Global.cell_size # the size of the actual boxes in the grid
var grid_size
var mouse_pressed = false

# @param: none
# @retur: void
# @descr: Godot std library function that runs all code a single time, when this object enters
# the scene tree
func _ready():
	create_grid()
	
func _process(delta):
	if mouse_pressed:
		var pos = Vector2i(get_global_mouse_position()) / cell_size
		if Global.grid.is_in_boundsv(pos):
			Global.grid.set_point_solid(pos, true)
		queue_redraw()
	
func _input(event):
	# clear walls if enter is pressed
	if Input.is_action_pressed("ui_accept"):
		clear_walls()
		
	# draw walls with left click
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				mouse_pressed = true
			else:
				mouse_pressed = false
		# Move start
		if event.button_index == MOUSE_BUTTON_MIDDLE and event.pressed:
			Global.start_pos = Vector2i(event.position) / cell_size
			queue_redraw()
		# Move end
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			Global.end_pos = Vector2i(event.position) / cell_size
			queue_redraw()

func clear_walls():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			Global.grid.set_point_solid(Vector2i(x, y), false)
	queue_redraw()

func fill_walls():
	for x in grid_size.x:
		for y in grid_size.y:
			if Global.grid.is_point_solid(Vector2i(x, y)):
				draw_rect(Rect2(x * cell_size.x, y * cell_size.y, cell_size.x, cell_size.y), Color.DARK_GRAY)

# @param: none
# @retur: void
# @descr: creates the actual grid that will be used by the visualizer, however, does not contain the code...
# that actually displays it / draws it to the screen.
func create_grid():
	grid_size = Vector2i(get_viewport_rect().size) / cell_size
	Global.grid.size = grid_size # not to be confused by meaning "size = size", but the AStarGrid2D size must be set
	Global.grid.cell_size = cell_size # ^ same thing as above, not to be confused
	Global.grid.offset = cell_size / 2 # calculate path to node from it's center, not it's corners
	Global.grid.update() # refresh the alrdy initiated grid variable with these new changes
	
func draw_grid():
	# draw every row onto the screen
	for rows in grid_size.x + 1:
		draw_line(Vector2(rows * cell_size.x, 0), Vector2(rows * cell_size.x, grid_size.y * cell_size.y), Color.SLATE_BLUE, 1)
		
	# draw every column onto the screen
	for columns in grid_size.y + 1:
		draw_line(Vector2(0, columns * cell_size.y), Vector2(grid_size.x * cell_size.x, columns * cell_size.y), Color.SLATE_BLUE, 1)
		
func draw_start_node():
	# draw the starting node
	draw_rect(Rect2(Global.start_pos * cell_size, cell_size), Color.LIGHT_GREEN)
	
func draw_end_node():
	#draw the end node
	draw_rect(Rect2(Global.end_pos * cell_size, cell_size), Color.ORANGE_RED)	

# @param: none
# @retur: void
# @descr: Godot std library function that belongs to the Canvas object in the Node2D interface being used...
# this function actually responds to "draw_line()" function calls and IS the code that ACTUALLY draws the debug grid
func _draw():
	draw_grid()
	draw_start_node()
	draw_end_node()
	fill_walls()
