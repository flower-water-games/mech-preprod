extends Node2D

class_name Cursor

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	_controller_update_position(delta)

func _input(event):
	if event is InputEventMouseMotion:
		_update_position()

func _update_position():
	global_position = get_global_mouse_position();

func _controller_update_position(delta):
	var mouse_pos = get_global_mouse_position()
	var cursor_velocity = Input.get_vector("cursor_left", "cursor_right", "cursor_up", "cursor_down")
	var direction = global_position.direction_to(global_position + cursor_velocity)
	global_position += (direction * 1000 * delta)
