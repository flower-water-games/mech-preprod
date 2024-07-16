extends Node2D

@export var remote_foot_target : Node2D
@export var flip_sprite : bool = false
@export var hip_location : Vector2 = Vector2.ZERO
@export var shin_texture : Texture2D

@onready var shin : Sprite2D = $Shin
@onready var leg_line : Line2D = $Line2D

func _ready():
	if not shin_texture == null:
		shin.texture = shin_texture
	
	if flip_sprite:
		shin.scale.y *= -1

func _process(delta):
	var distance_to_foot = shin.global_position.distance_to(remote_foot_target.foot.global_position)
	var leg_length : float = 20.0
	shin.global_position.y = remote_foot_target.foot.global_position.y - leg_length + remap(distance_to_foot, leg_length, 32, 0, 8)
	shin.position.x = remap(distance_to_foot, leg_length, 32, 0.0, 4.0)
	shin.rotation = shin.global_position.angle_to_point(remote_foot_target.foot.global_position)

	# Find shin connecting point
	var shin_offset : float = -8.0
	var shin_connecting_point = shin.global_position.direction_to(remote_foot_target.foot.global_position) * shin_offset
	
	
	# Draw the leg
	leg_line.clear_points()
	leg_line.add_point(hip_location)
	leg_line.add_point(shin.position + shin_connecting_point)
