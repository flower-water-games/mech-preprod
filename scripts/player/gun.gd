class_name Gun
extends Node2D

@export var fire_rate := 0.2
@export var bullet_scene : PackedScene

var can_fire := true
var fire_rate_timer := 0.0

func shoot() -> void:
	var b = bullet_scene.instantiate()
	b.global_position = global_position
	get_tree().get_root().add_child(b)

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
