extends CharacterBody2D

@export var bomb_velocity := Vector2(-150, 0)
@export var damage = 1

signal bomb_hit

func _ready():
	velocity = bomb_velocity

func _process(delta: float) -> void:
	var col = move_and_collide(velocity * delta)
	if (col):
		_handle_collision(col)

func _handle_collision(col : KinematicCollision2D) -> void:
	var collider = col.get_collider()
	if (collider.collision_layer == 1):
		bomb_hit.emit()
		collider.health.add_or_subtract_health_by_value(-damage)
		queue_free()
