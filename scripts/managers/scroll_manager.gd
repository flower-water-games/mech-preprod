extends Node
class_name ScrollManager

signal scroll_completed

@export var total_game_time: float = 30.0  # Total game duration in seconds
@export var difficulty_curve_texture: CurveTexture

var current_game_time: float = 0.0
var is_game_active: bool = false

func _ready():
	if not difficulty_curve_texture:
		printerr("Error: No difficulty curve texture set.")
	start_game()

func _process(delta):
	if is_game_active:
		current_game_time += delta
		if current_game_time >= total_game_time:
			is_game_active = false
			scroll_completed.emit()

func start_game():
	is_game_active = true
	current_game_time = 0.0

func stop_game():
	is_game_active = false

func reset_game():
	current_game_time = 0.0
	is_game_active = false

## Returns the raw progress of the game as a float between 0 and 1.
##
## Returns:
## float: A value between 0 (game start) and 1 (game end) representing the
## current progress.
func get_raw_progress() -> float:
	return clamp(current_game_time / total_game_time, 0.0, 1.0)

# Modifying game to simply work on time
func get_difficulty() -> float:
	return current_game_time
