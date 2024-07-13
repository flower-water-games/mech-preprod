extends Node2D

@export var offset_foot : bool = false

# Feet tracking
@export var sibling_foot : Node2D

@onready var line_2d : Line2D = $Line2D
@onready var foot : Sprite2D = $Foot
@onready var target_position_sprite : Sprite2D = $TargetPosition

var previous_position : Vector2 = Vector2.ZERO
var foot_position : Vector2 = Vector2.ZERO
var walk_distance : float = 48.0
var target_position : Vector2 = Vector2.ZERO

var foot_moving_forward : bool = false

# Offsetting feet
"""
If I am going right I need the top feet to be out of sync
If I am going up, I need the top feet to be out of sync
# How to tell if they are in sync
From a stopped position .. I need the right foot to move towards the target, and the left foot to be sliding away

if BOTH feet are approximately 75% away from the target in the same direction
Move one foot early

If both feet are the same distance from the target
 and the movement is ZERO ...
Then shift one foot closer to the target

If both feet are moving towards the target, then they are in sync ...
"""

func _ready():
	update_foot_offset.call_deferred()
	if offset_foot:
		foot.modulate = Color("Yellow")

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
	
	# Check if you are moving towards the target, 
	foot_moving_forward = foot.global_position.distance_to(global_target_position) > lerp_foot_position.distance_to(global_target_position)
	
	# Animation
	if foot_moving_forward:
		# If you are then Smoothly animate
		foot.global_position = lerp_foot_position
	else:
		# If you are not, then stick to the ground
		foot.global_position = foot_position
		# If your sibling is stuck
		if sibling_foot.foot_moving_forward == false and offset_foot == true:
			if foot.global_position.distance_to(global_target_position) > walk_distance * 0.5:
				# Move foot early
				foot_position = target_position_sprite.global_position

	# Store previous position
	previous_position = global_position

	# Feet should not be able to PASS through each other (Could be fixed just by walk_distance)
	# Feet need to remain OFFSET
