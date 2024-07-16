extends Node
class_name EnemyFactory

func create_enemy(enemy_type: GameContent.ENEMYTYPE) -> CharacterBody2D:
	var enemy = get_enemy_scene(enemy_type)
	if enemy:
		var instance := enemy.instantiate()
		instance.global_position.y += randf_range(-200, 200)
		return instance
	return null

func get_enemy_scene(enemy_type: GameContent.ENEMYTYPE) -> PackedScene:
	var retrieved = GameContent.ENEMYSCENES[enemy_type]
	return retrieved
