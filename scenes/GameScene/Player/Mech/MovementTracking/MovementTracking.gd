extends Node2D

@export var offset_foot : bool = false

# Feet tracking
@export var sibling_foot : Node2D

@onready var line_2d : Line2D = $Line2D
@onready var foot : Sprite2D = $Foot
@onready var target_position_sprite : Sprite2D = $TargetPosition

var previous_position : Vector2 = Vector2.ZERO
var foot_position : Vector2 = Vector2.ZERO
@export var walk_distance : float = 48.0
var target_position : Vector2 = Vector2.ZERO
var global_target_position : Vector2 = Vector2.ZERO

@export var offset_percent : float = 0.9

var foot_moving_forward : bool = false


func _ready():
	update_foot_offset.call_deferred()
	if offset_foot:
		foot.modulate = Color("Yellow")

func update_foot_offset():
	foot_position = global_position
	previous_position = global_position

func _process(delta):
	# Moving direction
	var moving_direction = previous_position.direction_to(global_position)
	var target_position = moving_direction * walk_distance
	if target_position != Vector2.ZERO:
		# Move foot to new position and randomize it a little bit
		var offset_amount : float = (walk_distance * randf_range(0.8, 1.0)) - walk_distance
		var random_offset = randf_range(-offset_amount, offset_amount)
		var offset_position_tangentially : Vector2 = moving_direction.normalized().orthogonal() * random_offset
		target_position_sprite.position = target_position + offset_position_tangentially
	
	
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
	var lerp_speed : float = 0.15
	lerp_foot_position.x = lerpf(foot.global_position.x, foot_position.x, lerp_speed)
	lerp_foot_position.y = lerpf(foot.global_position.y, foot_position.y, lerp_speed)

	# Smooth animate the jump between positions
	global_target_position = target_position_sprite.global_position
	
	# Check if you are moving towards the target, 
	foot_moving_forward = foot.global_position.distance_to(global_target_position) > lerp_foot_position.distance_to(global_target_position)
	
	# Animation
	if foot_moving_forward:
		# If you are then Smoothly animate
		foot.global_position = lerp_foot_position
	else:
		# If you are not, then stick to the ground
		foot.global_position = foot_position
		# If your sibling is too in sync
		if foot.global_position.distance_to(global_target_position) > walk_distance * offset_percent:
				if sibling_foot.foot_moving_forward == false and offset_foot == true:
					foot_position = target_position_sprite.global_position
	
	# Store previous position
	previous_position = global_position
