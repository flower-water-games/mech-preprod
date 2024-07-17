extends Node2D

@export var top_left_leg : Node2D
@export var top_right_leg : Node2D
@export var bottom_left_leg : Node2D
@export var bottom_right_leg : Node2D

@onready var body : Sprite2D = $Shadow/Body
@onready var head : Sprite2D = $Head

func _ready():
	pass

func _process(delta):
	var target_center = get_center_of_positions(top_left_leg.foot.global_position, top_right_leg.foot.global_position, bottom_left_leg.foot.global_position, bottom_right_leg.foot.global_position)
	global_position.x = lerpf(global_position.x, target_center.x, 0.05)
	global_position.y = lerpf(global_position.y, target_center.y, 0.05)

	# Head rotate
	head.global_position = body.global_position
	head.rotation = (global_position + Vector2(0, -64)).angle_to_point(target_center) - deg_to_rad(90)


func get_center_of_positions(pos1, pos2, pos3, pos4):
	var center_x = (pos1.x + pos2.x + pos3.x + pos4.x) / 4
	var center_y = (pos1.y + pos2.y + pos3.y + pos4.y) / 4
	return Vector2(center_x, center_y)
