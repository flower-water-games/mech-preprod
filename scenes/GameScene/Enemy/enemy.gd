extends CharacterBody2D
class_name Enemy

enum MovementType {
	LINEAR,
	VERTICAL_SPLINE,
	STOPPED
}

@onready var health : Health = $Health

@export var speed := Vector2(-125, 0)
@export var on_hit_damage = 0.1
@export var movement_type : MovementType = MovementType.VERTICAL_SPLINE
@export var spline_amplitude := 100.0  # Maximum vertical displacement
@export var spline_frequency := 3.5  # How fast the enemy moves up and down
@export var spline_randomized := false
@export var score = 50 # when enemy dies, how much score
@export var bomber := false
@export var AP: AnimationPlayer
@onready var sfx_player : AudioStreamPlayer = $AudioStreamPlayer

signal enemy_died

var _throw_timer: Timer
var _spline_time = 0.9
var _spline_initial_y : float
var _cur_movement: MovementType
var _bombtarget: BombTarget

var _actor_state: ACTOR_STATE
enum ACTOR_STATE {
	run,
	dead,
	windup,
	throw
}

#region Initialization

func _ready() -> void:
	_init_properties()

func _init_properties():
	_actor_state = ACTOR_STATE.run

	health.died.connect(_enemy_die)
	AP.animation_finished.connect(_deathanim_end)

	_cur_movement = movement_type
	velocity = speed
	if (spline_randomized):
		_spline_initial_y = global_position.y + randf_range(-350, 350)
	else:
		_spline_initial_y = global_position.y

	if (bomber):
		_init_throw_timer()

#endregion

#region Processing

func _process(delta: float) -> void:
	_spline_time += delta
	_process_animations()
	_check_cleanup()

func _physics_process(delta: float) -> void:
	_process_movement(delta)

func _process_animations():
	match _actor_state:
		ACTOR_STATE.run:
			AP.play("run")
		ACTOR_STATE.dead:
			AP.play("death")
		ACTOR_STATE.windup:
			AP.play("windup")
		ACTOR_STATE.throw:
			AP.play("throw")

#endregion

#region Bomber Logic

func _init_throw_timer():
	_throw_timer = Timer.new()
	_throw_timer.wait_time = 1
	_throw_timer.autostart = true
	_throw_timer.one_shot = true
	_throw_timer.timeout.connect(_initbombthrow)
	add_child(_throw_timer)

func _initbombthrow():
	if _isdead():
		return
	AP.animation_finished.connect(_windupanim_end)
	_bombtarget = GameContent.BombTargetSc.instantiate()
	add_sibling(_bombtarget)
	_actor_state = ACTOR_STATE.windup
	_cur_movement = MovementType.STOPPED

func _windupanim_end(animation_name):
	if _isdead():
		return
	if animation_name == "windup":
		_actor_state = ACTOR_STATE.throw
		AP.animation_finished.connect(_throwanim_end)
		var bombscene = GameContent.Bomb.instantiate()
		bombscene.bomb_target = _bombtarget
		bombscene.position = position
		add_sibling(bombscene)

func _throwanim_end(animation_name):
	if _isdead():
		return
	if animation_name == "throw":
		_actor_state = ACTOR_STATE.run
		_cur_movement = movement_type
		velocity = speed

#endregion

#region Movement and Collisions

func _process_movement(delta):
	match _cur_movement:
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
	var vertical_movement = sin(_spline_time * spline_frequency) * spline_amplitude
	var target_position = Vector2(global_position.x + horizontal_movement, _spline_initial_y + vertical_movement)

	var collision = move_and_collide(target_position - global_position)
	if collision:
		_handle_hit_collision(collision)

func _handle_hit_collision(col : KinematicCollision2D) -> void:
	var collider : Node2D = col.get_collider()
	if collider.is_in_group("Player"):
		collider.health.add_or_subtract_health_by_value(-on_hit_damage)

#endregion

#region Death and Cleanup

func _isdead():
	return _actor_state == ACTOR_STATE.dead

func _enemy_destroy() -> void:
	queue_free()
	if is_instance_valid(_bombtarget):
		_bombtarget.queue_free()

func _enemy_die() -> void:
	enemy_died.emit()
	_cur_movement = MovementType.STOPPED
	_actor_state = ACTOR_STATE.dead
	collision_layer = 0
	var explodefx = GameContent.FXEnemyExplode.instantiate()
	add_child(explodefx)

func _deathanim_end(animation_name):
	if animation_name == "death":
		_enemy_destroy()

func _check_cleanup():
	if (global_position.x <= -100):
		_enemy_destroy()

#endregion
