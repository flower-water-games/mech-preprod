extends Node
class_name BulletFactory

enum BulletType { PLAYER_BULLET}
@export var player_bullet : PackedScene

func create_bullet(bullet_type : BulletType) -> CharacterBody2D:
	var b = get_bullet_scene(bullet_type)
	if (b):
		var instance = b.instantiate()
		return instance
	return null

func get_bullet_scene(bullet_type : BulletType):
	match bullet_type:
		BulletType.PLAYER_BULLET:
			return player_bullet
	return null
