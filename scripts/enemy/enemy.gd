extends Node2D

@onready var health : Health = $Health

func _ready() -> void:
	Spawning.bullet_collided_body.connect(enemy_collided)
	health.died.connect(enemy_die) 

var time_passed = 0.9
func _process(delta: float) -> void:
	time_passed += delta
	if time_passed >= 1.0:
		shoot()
		time_passed = 0.0


func enemy_collided(body, body_shape_index, bullet, local_shape_index, shared_area) -> void:
	# Your custom code here
	health.add_or_subtract_health_by_value(-bullet.props.damage)
	pass # Replace with function body.

func enemy_die() -> void:
	queue_free()

func shoot() -> void:
	var spawn_data = {
		"position" : global_position,
		"rotation": global_rotation,
	}
	Spawning.spawn(spawn_data, "two" ,"1")
