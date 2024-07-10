extends CharacterBody2D

@export var bullet_dir := Vector2(150, 0)
@export var bullet_spd := 5000
@export var damage = 1

func _ready():
	velocity = bullet_dir * bullet_spd

func _process(delta: float) -> void:
	var col = move_and_collide(velocity * delta)
	if (col):
		_handle_collision(col)

func _handle_collision(col : KinematicCollision2D) -> void:
	var collider = col.get_collider()
	if (collider.collision_layer == 2):
		collider.health.add_or_subtract_health_by_value(-damage)
		queue_free()
