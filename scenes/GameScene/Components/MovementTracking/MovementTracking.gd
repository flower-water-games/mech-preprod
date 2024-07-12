extends Node2D

@export var offset_foot : bool = false

@onready var line_2d : Line2D = $Line2D
@onready var foot : Sprite2D = $Foot
@onready var target_position_sprite : Sprite2D = $TargetPosition

var previous_position : Vector2 = Vector2.ZERO
var foot_position : Vector2 = Vector2.ZERO
var walk_distance : float = 48.0
var target_position : Vector2 = Vector2.ZERO

func _ready():
	update_foot_offset.call_deferred()

func update_foot_offset():
	foot_position = global_position
	previous_position = global_position
	if offset_foot:
		foot_position -= Vector2(walk_distance * 0.5, 0)

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

	# Pre-calculate the new position
	var lerp_foot_position : Vector2 = Vector2.ZERO
	lerp_foot_position.x = lerpf(foot.global_position.x, foot_position.x, 0.1)
	lerp_foot_position.y = lerpf(foot.global_position.y, foot_position.y, 0.1)

	# Check if you are moving towards the TARGET
	# If you are then LERP
	# If you are moving away then STICK TO THE GROUND
	
	# Smooth animate the jump between positions
	var global_target_position = target_position_sprite.global_position
	if foot.global_position.distance_to(global_target_position) > lerp_foot_position.distance_to(global_target_position):
		foot.global_position = lerp_foot_position
	else:
		foot.global_position = foot_position

	# Store previous position
	previous_position = global_position

	# Feet should not be able to PASS through each other (Could be fixed just by walk_distance)
	# Feet need to remain OFFSET
