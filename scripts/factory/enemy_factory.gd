extends Node
class_name EnemyFactory

enum EnemyType { WEAK, NORMAL, STRONG, BOSS }

@export var weak_enemy_scene: PackedScene
@export var normal_enemy_scene: PackedScene
@export var strong_enemy_scene: PackedScene

# prob needs special case
@export var boss_enemy_scene: PackedScene

@onready var spawn_point : Node2D = get_node("/root/MainGameScene/World2D/SpawnPoint")

func create_enemy(enemy_type: EnemyType) -> CharacterBody2D:
	var enemy = get_enemy_scene(enemy_type)
	if enemy:
		var instance := enemy.instantiate()
		spawn_point.add_child(instance)
		instance.global_position.y += randf_range(-200, 200)
		print("spawning enemy")
		return instance
	return null

func get_enemy_scene(enemy_type: EnemyType) -> PackedScene:
	match enemy_type:
		EnemyType.WEAK:
			return weak_enemy_scene
		EnemyType.NORMAL:
			return normal_enemy_scene
		EnemyType.STRONG:
			return strong_enemy_scene
		EnemyType.BOSS:
			return boss_enemy_scene
	return null