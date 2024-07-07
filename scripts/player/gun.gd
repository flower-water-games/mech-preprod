extends Node2D
class_name Gun

@export var fire_rate := 0.2
@export var bullet_scene : PackedScene

var can_fire := true
var fire_rate_timer := 0.0

signal gun_shot(position : Vector2)

func shoot() -> void:
	gun_shot.emit(global_position)
	#TODO put an sfx manager in the services
	$AudioStreamPlayer.play()

func _physics_process(delta: float) -> void:
	# Shooting
	if Input.is_action_pressed("shoot") and can_fire:
		shoot()
		can_fire = false
		fire_rate_timer = fire_rate
		
	# Fire rate cooldown
	if not can_fire:
		fire_rate_timer -= delta
		if fire_rate_timer <= 0:
			can_fire = true
