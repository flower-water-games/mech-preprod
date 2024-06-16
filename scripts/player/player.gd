class_name Player
extends CharacterBody2D

@export var speed := 200.0
@export var health := 100.0
@export var damage := 10.0
@export var fire_rate := 0.2

var can_fire := true
var fire_rate_timer := 0.0

@onready var gun := $Gun

func _ready() -> void:
	gun.damage = damage
	gun.fire_rate = fire_rate

func _physics_process(delta: float) -> void:
	# Movement
	var input_vector := Vector2.ZERO
	input_vector.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_vector.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	input_vector = input_vector.normalized()
	
	var new_position := global_position + input_vector * speed * delta
	
	velocity = (new_position - global_position).normalized() * speed
	move_and_slide()
	
	# Shooting
	if Input.is_action_pressed("shoot") and can_fire:
		gun.shoot()
		can_fire = false
		fire_rate_timer = fire_rate
		
	# Fire rate cooldown
	if not can_fire:
		fire_rate_timer -= delta
		if fire_rate_timer <= 0:
			can_fire = true

func take_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		die()

func die() -> void:
	# Handle player death
	pass
