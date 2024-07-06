extends CharacterBody2D
class_name Enemy

@onready var health : Health = $Health

# tweakable parameters
@export var custom_velocity := Vector2(-50, 0)
@export var shoots := false

signal enemy_died()

func _ready() -> void:
	Spawning.bullet_collided_body.connect(enemy_collided)
	health.died.connect(enemy_die) 
	velocity = custom_velocity

var time_passed = 0.9
func _process(delta: float) -> void:
	time_passed += delta
	if time_passed >= .2 && shoots:
		shoot()
		time_passed = 0.0

func _physics_process(_delta: float) -> void:
	move_and_slide()


func enemy_collided(_body:CollisionObject2D,_body_shape_index:int, _bullet:Dictionary, _local_shape_index:int,_shared_area:Area2D):
	if (_body.collision_layer == 2 && _body == self):
		health.add_or_subtract_health_by_value(-_bullet.props.damage)

func enemy_die() -> void:
	enemy_died.emit()
	queue_free()

func shoot() -> void:
	# var new_x = global_position.x  -190
	var spawn_data = {
		"position" : global_position,
		"rotation": global_rotation,
	}
	Spawning.spawn(spawn_data, "two" ,"1")
