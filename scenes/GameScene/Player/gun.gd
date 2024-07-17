extends Node2D
class_name Gun

@export var initial_fire_rate := 0.1
@export var max_fire_rate := 0.04
@export var ramp_up_time := 3.0
@export var bullet_scene : PackedScene
@export var cursor: Cursor
@export var bulletspawn: Node2D
@export var gunpos: Sprite2D

var current_fire_rate := 0.2
var can_fire := true
var fire_rate_timer := 0.0
var continuous_fire_timer := 0.0
var is_shooting := false

signal gun_shot(position : Vector2)
signal fire_rate_changed(rate : float)

func shoot() -> void:
	# "signal up" to game manager to actually handle spawning the bullet, but from this node's location
	gun_shot.emit(bulletspawn.global_position)

func _physics_process(delta: float) -> void:

	#region Shooting
	if Input.is_action_pressed("shoot"):
		if can_fire:
			shoot()
			gunpos.position = gunpos.position.direction_to(cursor.position) * -8.0
			can_fire = false
			fire_rate_timer = current_fire_rate

		# Increase fire rate over time
		continuous_fire_timer += delta
		var t = min(continuous_fire_timer / ramp_up_time, 1.0)
		current_fire_rate = lerp(initial_fire_rate, max_fire_rate, t)
		fire_rate_changed.emit(current_fire_rate)

		is_shooting = true
	else:
		# Reset fire rate when not shooting
		continuous_fire_timer = 0
		current_fire_rate = initial_fire_rate
		is_shooting = false

	# Fire rate cooldown
	if not can_fire:
		fire_rate_timer -= delta
		if fire_rate_timer <= 0:
			can_fire = true
	#endregion

	_rotate_turret()

	# Return to position
	gunpos.position.x = lerpf(gunpos.position.x, 0, 0.2)
	gunpos.position.y = lerpf(gunpos.position.y, 0, 0.2)

func _rotate_turret():
	gunpos.rotation = gunpos.position.angle_to_point(cursor.position)

func is_currently_shooting() -> bool:
	return is_shooting
