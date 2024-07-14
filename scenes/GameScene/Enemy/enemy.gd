extends CharacterBody2D
class_name Enemy

enum MovementType {
	LINEAR,
	VERTICAL_SPLINE,
	STOPPED
}

@onready var health : Health = $Health

@export var bomber := false
@export var custom_velocity := Vector2(-125, 0)
@export var on_hit_damage = 0.1
@export var movement_type : MovementType = MovementType.VERTICAL_SPLINE
@export var spline_amplitude := 100.0  # Maximum vertical displacement
@export var spline_frequency := 3.5  # How fast the enemy moves up and down
@export var spline_randomized := false
@export var score = 50 # when enemy dies, how much score

signal enemy_died

var spline_time = 0.9
var spline_initial_y : float
var player : Player

var _actor_state: ACTOR_STATE
enum ACTOR_STATE {
	run,
	dead,
	throwing,
	throw
}

func _ready() -> void:
	_init_properties()

func _init_properties():
	_actor_state = ACTOR_STATE.run

	health.died.connect(_enemy_die)
	$SpriteSheet/AnimationPlayer.animation_finished.connect(_deathanim_end)

	velocity = custom_velocity
	if (spline_randomized):
		spline_initial_y = global_position.y + randf_range(-350, 350)
	else:
		spline_initial_y = global_position.y

func _process(delta: float) -> void:
	spline_time += delta
	_process_animations()
	_check_cleanup()

func _check_cleanup():
	if (global_position.x <= -100):
		_enemy_destroy()

func _process_animations():
	var AP = $SpriteSheet/AnimationPlayer
	match _actor_state:
		ACTOR_STATE.run:
			AP.play("run")
		ACTOR_STATE.dead:
			AP.play("death")

func _physics_process(delta: float) -> void:
	_process_movement(delta)

func _process_movement(delta):
	match movement_type:
		MovementType.LINEAR:
			_move_linear(delta)
		MovementType.VERTICAL_SPLINE:
			_move_vertical_spline(delta)
		MovementType.STOPPED:
			velocity = Vector2(0,0)
			move_and_slide()

func _move_linear(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		_handle_hit_collision(collision)

func _move_vertical_spline(delta: float) -> void:
	var horizontal_movement = velocity.x * delta
	var vertical_movement = sin(spline_time * spline_frequency) * spline_amplitude
	var target_position = Vector2(global_position.x + horizontal_movement, spline_initial_y + vertical_movement)

	var collision = move_and_collide(target_position - global_position)
	if collision:
		_handle_hit_collision(collision)

func _handle_hit_collision(col : KinematicCollision2D) -> void:
	var collider : Node2D = col.get_collider()
	if collider.is_in_group("Player"):
		collider.health.add_or_subtract_health_by_value(-on_hit_damage)

#region Death and Cleanup

func _enemy_destroy() -> void:
	queue_free()

func _enemy_die() -> void:
	enemy_died.emit()
	movement_type = MovementType.STOPPED
	_actor_state = ACTOR_STATE.dead
	collision_layer = 0

func _deathanim_end(animation_name):
	if animation_name == "death":
		_enemy_destroy()

#endregion
