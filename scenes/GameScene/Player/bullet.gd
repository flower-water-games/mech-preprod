extends CharacterBody2D

@export var bullet_dir := Vector2(150, 0)
@export var bullet_spd := 5000
@export var damage = 1
@export var line: Line2D

func _ready():
	velocity = bullet_dir * bullet_spd
	_randomize_line()

func _randomize_line():
	var linebegin = line.points[0]
	linebegin.x += randi_range(-30, 0)
	line.points[0] = linebegin

	var lineend = line.points[1]
	lineend.x += randi_range(0, 30)
	line.points[1] = lineend

	line.width += randi_range(0, 2)


func _process(delta: float) -> void:
	var col = move_and_collide(velocity * delta)
	if (col):
		_handle_collision(col)

func _handle_collision(col : KinematicCollision2D) -> void:
	var collider = col.get_collider()
	if (collider.collision_layer == 2):
		collider.health.add_or_subtract_health_by_value(-damage)
		queue_free()
