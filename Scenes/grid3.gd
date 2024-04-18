extends Node2D

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
 # the grid object itself
var grid_size: Vector2i
var cell_size = Global.cell_size
var mouse_pressed = false

# // - - - - - - - - - - - - - - - - - - - - - - - - -
func _draw():
	_draw_grid()
	_draw_start_node()
	_draw_end_node()
	_fill_walls()

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _ready():
	_create_grid()

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _process(delta):
	if mouse_pressed:
		var pos = Vector2i(get_global_mouse_position()) / cell_size
		if Global.grid.is_in_boundsv(pos):
			Global.grid.set_point_solid(pos, true)
		queue_redraw()


# GRID LOGIC


# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _create_grid() -> void:
	grid_size = Vector2i(get_viewport_rect().size) / cell_size
	Global.grid.size = grid_size
	Global.grid.cell_size = cell_size
	Global.grid.offset = cell_size / 2
	Global.grid.update()

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func _draw_grid():
	for rows in Global.grid.size.x + 1:
		draw_line(Vector2(rows * cell_size.x, 0), Vector2(rows * cell_size.x, grid_size.y * cell_size.y), Color.BISQUE, 1)

	for columns in Global.grid.size.y + 1:
		draw_line(Vector2(0, columns * cell_size.y), Vector2(grid_size.x * cell_size.x, columns * cell_size.y), Color.BISQUE, 1)

# // - - - - - - - - - - - - - - - - - - - - - - - - -
func _draw_start_node():
	draw_rect(Rect2(Global.start_pos * cell_size, cell_size), Color.LIGHT_GREEN)

# // - - - - - - - - - - - - - - - - - - - - - - - - -
func _draw_end_node():
	draw_rect(Rect2(Global.end_pos * cell_size, cell_size), Color.ORANGE_RED)


# INPUT / WALLS LOGIC


# // - - - - - - - - - - - - - - - - - - - - - - - - -
func _input(event):
	# clear walls if enter is pressed
	if Input.is_action_pressed("ui_accept"):
		_clear_walls()
		
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
			print("New Start Pos: \t " + str(Global.start_pos))
			queue_redraw()
		# Move end
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			Global.end_pos = Vector2i(event.position) / cell_size
			print("New End Pos: \t " + str(Global.end_pos))
			queue_redraw()

# // - - - - - - - - - - - - - - - - - - - - - - - - -
func _clear_walls():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			Global.grid.set_point_solid(Vector2i(x, y), false)
	queue_redraw()
	print("Walls cleared!")

# // - - - - - - - - - - - - - - - - - - - - - - - - -
func _fill_walls():
	for x in grid_size.x:
		for y in grid_size.y:
			if Global.grid.is_point_solid(Vector2i(x, y)):
				draw_rect(Rect2(x * cell_size.x, y * cell_size.y, cell_size.x, cell_size.y), Color.DARK_GRAY)
	queue_redraw()
