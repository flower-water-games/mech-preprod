extends Node2D

@onready var line_2d : Line2D = $Line2D

var track_position : Vector2 = Vector2.ZERO
var walk_distance : float = 96.0

var relative_foot_position : Vector2 = Vector2.ZERO

func _ready():
	update_position.call_deferred()

func update_position():
	track_position = global_position

func _process(delta):
	# Move foot position
	var relative_position = track_position - global_position
	var distance_from_previous_position = global_position.distance_to(track_position)
	
	# Update position
	line_2d.clear_points()
	line_2d.add_point(Vector2.ZERO)
	line_2d.add_point(relative_position)

	# Update tracking if you move past the distance
	if distance_from_previous_position > walk_distance:
		update_position()
