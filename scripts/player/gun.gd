class_name Gun
extends Node2D

@export var fire_rate := 0.2

var can_fire := true
var fire_rate_timer := 0.0

func shoot() -> void:
	var spawn_data = {
		"position" : global_position,
		"rotation": global_rotation,
	}
	Spawning.spawn(spawn_data, "one" ,"0")

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