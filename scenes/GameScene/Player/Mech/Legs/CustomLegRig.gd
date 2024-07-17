extends Node2D

@export var remote_foot_target : Node2D
@export var flip_sprite : bool = false
@export var hip_location : Vector2 = Vector2.ZERO
@export var shin_texture : Texture2D
@export var shin_distort : bool = false
@export var shin_offset : Vector2 = Vector2.ZERO
@export var line_zindex : int = 0
@export var shin_zindex : int = 0

@onready var shin : Sprite2D = $Shin
@onready var leg_line : Line2D = $Line2D

var shin_scale : Vector2 = Vector2(1, 1)

func _ready():
	leg_line.z_index = line_zindex
	shin.z_index = shin_zindex

	if not shin_texture == null:
		shin.texture = shin_texture

	if flip_sprite:
		shin.scale.y *= -1

	shin_scale = shin.scale

func _process(delta):
	var distance_to_foot = shin.global_position.distance_to(remote_foot_target.foot.global_position)
	var leg_length : float = 20.0
	shin.global_position.y = remote_foot_target.foot.global_position.y - leg_length + remap(distance_to_foot, leg_length, 32, 0, 8)
	shin.position.x = remap(distance_to_foot, leg_length, 32, 0.0, 4.0) + shin_offset.x
	shin.rotation = shin.global_position.angle_to_point(remote_foot_target.foot.global_position)

	# Find shin connecting point
	var shin_offset : float = -8.0
	var shin_connecting_point = shin.global_position.direction_to(remote_foot_target.foot.global_position) * shin_offset

	# Distort the shin if it is the middle one
	#if shin_distort:
	#	shin.scale.x = shin_scale.x - remap(hip_location.distance_to(shin.position), 0.0, 64.0, 0.0, shin_scale.x * 0.5)

	# Draw the leg
	#leg_line.clear_points()
	#leg_line.add_point(hip_location)
	#leg_line.add_point(shin.position + shin_connecting_point)
	#leg_line.add_point(remote_foot_target.foot.global_position - global_position)
