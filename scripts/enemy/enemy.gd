extends CharacterBody2D
class_name Enemy

enum MovementType {
	LINEAR,
	VERTICAL_SPLINE,
	STOPPED
}

@onready var health : Health = $Health

# Tweakable parameters
@export var custom_velocity := Vector2(-250, 0)
@export var shoots := false
@export var on_hit_damage = 5
@export var health_value = 2
@export var movement_type : MovementType = MovementType.VERTICAL_SPLINE
@export var spline_amplitude := 100.0  # Maximum vertical displacement
@export var spline_frequency := 3.5  # How fast the enemy moves up and down
@export var spline_randomized := false

# after this value of time has elapsed, kill this entity
var lifetime = 10.0
var death_timer : Timer
@onready var audio_sfx : AudioStreamPlayer = $AudioStreamPlayer
signal enemy_died

var time_passed = 0.9
var initial_y_position : float

func _ready() -> void:
	health.set_max_health(health_value)
	health.died.connect(enemy_die) 
	velocity = custom_velocity
	if (spline_randomized):

		initial_y_position = global_position.y + randf_range(-350, 350)
	else:
		initial_y_position = global_position.y

	enemy_died.connect(audio_sfx.play)
	# set up death timer
	 # Set up and start the death timer
	death_timer = Timer.new()
	death_timer.set_one_shot(true)
	death_timer.set_wait_time(lifetime)
	death_timer.timeout.connect(enemy_destroy)
	add_child(death_timer)
	death_timer.start()


func _process(delta: float) -> void:
	time_passed += delta
	if (shoots):
		shoot()

func _physics_process(delta: float) -> void:
	match movement_type:
		MovementType.LINEAR:
			move_linear(delta)
		MovementType.VERTICAL_SPLINE:
			move_vertical_spline(delta)
		MovementType.STOPPED:
			velocity = Vector2(0,0)
			move_and_slide()

func move_linear(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		_handle_hit_collision(collision)

func move_vertical_spline(delta: float) -> void:
	var horizontal_movement = velocity.x * delta
	var vertical_movement = sin(time_passed * spline_frequency) * spline_amplitude
	var target_position = Vector2(global_position.x + horizontal_movement, initial_y_position + vertical_movement)
	
	var collision = move_and_collide(target_position - global_position)
	if collision:
		_handle_hit_collision(collision)

func _handle_hit_collision(col : KinematicCollision2D) -> void:
	var collider : Node2D = col.get_collider() 
	if collider.is_in_group("Player"):
		collider.health.add_or_subtract_health_by_value(-on_hit_damage)
		enemy_die()

func enemy_destroy() -> void:
	queue_free()

func enemy_die() -> void:
	enemy_died.emit()
	movement_type = MovementType.STOPPED
	# short delay before destroying itself for sfx to play
	await get_tree().create_timer(0.5).timeout
	queue_free()

func shoot() -> void:
	#identify current target position
	# spawn a target
	# wait some time ("target_wait")
	# shoot high velocity bullet
	print("enemy pew")
	return