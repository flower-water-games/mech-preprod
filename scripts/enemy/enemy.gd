extends CharacterBody2D
class_name Enemy

@onready var health : Health = $Health

func _ready() -> void:
	Spawning.bullet_collided_body.connect(enemy_collided)
	health.died.connect(enemy_die) 
	velocity = Vector2(-50,0) 

var time_passed = 0.9
func _process(delta: float) -> void:
	time_passed += delta
	if time_passed >= .2:
		shoot()
		time_passed = 0.0

func _physics_process(delta: float) -> void:
	move_and_slide()


func enemy_collided(body:CollisionObject2D,body_shape_index:int, bullet:Dictionary, local_shape_index:int,shared_area:Area2D):
	if (body.collision_layer == 2):
		health.add_or_subtract_health_by_value(-bullet.props.damage)

func enemy_die() -> void:
	queue_free()

func shoot() -> void:
	var new_x = global_position.x  -190
	var spawn_data = {
		"position" : Vector2(new_x, global_position.y),
		"rotation": global_rotation,
	}
	Spawning.spawn(spawn_data, "two" ,"1")
