extends CharacterBody2D
class_name Enemy

@onready var health : Health = $Health

# tweakable parameters
@export var custom_velocity := Vector2(-50, 0)
@export var shoots := false
@export var on_hit_damage = 5
@export var health_value = 2

signal enemy_died

func _ready() -> void:
	health.set_max_health(health_value)
	health.died.connect(enemy_die) 
	velocity = custom_velocity

var time_passed = 0.9
func _process(delta: float) -> void:
	time_passed += delta
	if shoots && time_passed >= .2: 
		shoot()
		time_passed = 0.0

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		_handle_hit_collision(collision)

func _handle_hit_collision(col : KinematicCollision2D) -> void:
	var collider : Node2D = col.get_collider() 
	if collider.is_in_group("Player"):
		collider.health.add_or_subtract_health_by_value(-on_hit_damage)
		enemy_die()


func enemy_die() -> void:
	enemy_died.emit()
	queue_free()

func shoot() -> void:
	#identify current target position
	# spawn a target
	# wait some time ("target_wait")
	# shoot high velocity bullet
	print("enemy pew")
	return

