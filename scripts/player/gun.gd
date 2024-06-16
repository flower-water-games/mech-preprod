class_name Gun
extends Node2D

@export var bullet_scene: PackedScene
@export var damage := 10.0
@export var bullet_speed := 400.0
@export var bullet_lifetime := 2.0

func shoot() -> void:
	spawn_bullet()

func spawn_bullet() -> void:
	var bullet := bullet_scene.instantiate() as Bullet
	bullet.damage = damage
	bullet.velocity = Vector2.RIGHT.rotated(global_rotation) * bullet_speed
	bullet.lifetime = bullet_lifetime
	add_child(bullet)
