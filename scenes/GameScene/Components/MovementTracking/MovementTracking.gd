extends Node2D

@export var offset_foot : bool = false

@onready var line_2d : Line2D = $Line2D
@onready var foot : Sprite2D = $Foot
@onready var target_position_sprite : Sprite2D = $TargetPosition

var previous_position : Vector2 = Vector2.ZERO

var foot_position : Vector2 = Vector2.ZERO
var walk_distance : float = 64.0

var target_position : Vector2 = Vector2.ZERO

func _ready():
	update_foot_offset.call_deferred()

func update_foot_offset():
	update_position()
	previous_position = global_position
	if offset_foot:
		foot_position -= Vector2(walk_distance * 0.5, 0)

func update_position():
	foot_position = global_position

func _process(delta):
	# Moving direction
	var moving_direction = previous_position.direction_to(global_position)
	var target_position = moving_direction * walk_distance
	if target_position != Vector2.ZERO:
		target_position_sprite.position = target_position

	# Update tracking if you move past the distance
	if foot_position.distance_to(global_position) >= walk_distance:
		foot_position = target_position_sprite.global_position
	
	# Move foot position
	var relative_foot_position = foot_position - global_position

	# Update position
	line_2d.clear_points()
	line_2d.add_point(Vector2.ZERO)
	line_2d.add_point(relative_foot_position)
	
	# Smooth animate the jump between positions
	foot.global_position.x = lerpf(foot.global_position.x, foot_position.x, 0.1)
	foot.global_position.y = lerpf(foot.global_position.y, foot_position.y, 0.1)

	# Store previous position
	previous_position = global_position
