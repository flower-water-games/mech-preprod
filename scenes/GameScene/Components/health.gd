extends Node2D
class_name Health

signal health_changed(value)
signal died()

@onready var progress_bar : ProgressBar = $ProgressBar

# Variables
@export var max_health : float = 100.0
var current_health : float = 100.0

# Color Gradient
var health_color_gradient = load("res:///resources/HealthColorGradient.tres")

func _ready():
	modulate = health_color_gradient.sample(1.0)
	update_progress_bar()

func is_dead():
	return (current_health <= 0)

func set_max_health(new_value):
	max_health = new_value
	current_health = max_health
	update_progress_bar()

func add_or_subtract_health_by_value(new_value):
	# Update health
	current_health = clamp(current_health + new_value, 0.0, max_health) # Add
	update_progress_bar()

func update_progress_bar():
	# Update the value
	var weight = (current_health / max_health)
	var value = int(weight * 100.0) # Update progress bar

	# Let the parent know it died
	if value <= 0:
		died.emit()

	if value != progress_bar.value:
		health_changed.emit(value)

	progress_bar.value = value
	# Change the color
	modulate = health_color_gradient.sample(weight)
