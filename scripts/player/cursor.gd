extends Node2D

class_name Cursor

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	_update_position()

func _update_position():
	global_position = get_global_mouse_position();
