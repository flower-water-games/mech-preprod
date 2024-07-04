class_name Gun
extends Node2D

var bullet_scene: PackedScene
var damage := 10.0
var bullet_speed := 400.0
var bullet_lifetime := 2.0
@onready var bullet_spawner : Spawning = get_node("/root/Spawning") 

func shoot() -> void:
	# spawn_bullet()
	var spawn_data = {
		"position" : global_position,
		"rotation": global_rotation,
	}
	bullet_spawner.spawn(spawn_data, "one" ,"0")

func spawn_bullet() -> void:
	var bullet := bullet_scene.instantiate() as Bullet
	bullet.damage = damage
	bullet.velocity = Vector2.RIGHT.rotated(global_rotation) * bullet_speed
	bullet.lifetime = bullet_lifetime
	get_node("/root/").add_child(bullet)
	bullet.transform.origin = global_position
