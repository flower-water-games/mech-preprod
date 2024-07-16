extends Node
class_name EnemyFactory

# Rectangles setup where points are in order of math quadrants 2, 3, 4, 1
var SPAWNS = {
	GameContent.SPAWNLOC.Top: Polygon2D,
	GameContent.SPAWNLOC.Middle: Polygon2D,
	GameContent.SPAWNLOC.Bottom: Polygon2D,
}

@export var STop: SpawnRectangle
@export var SMid: SpawnRectangle
@export var SBtm: SpawnRectangle
@export var SpawnNodeGroup: Node2D

func _ready():
	SPAWNS[GameContent.SPAWNLOC.Top] = STop
	SPAWNS[GameContent.SPAWNLOC.Middle] = SMid
	SPAWNS[GameContent.SPAWNLOC.Bottom] = SBtm

func create_enemy(enemy_type: GameContent.ENEMYTYPE, location: GameContent.SPAWNLOC) -> CharacterBody2D:
	var enemy = get_enemy_scene(enemy_type)
	if enemy:
		var instance := enemy.instantiate()
		var spawn_location = SPAWNS[location]
		SpawnNodeGroup.add_child(instance)
		instance.global_position = spawn_location.get_spawn_point()
		return instance
	return null

func get_enemy_scene(enemy_type: GameContent.ENEMYTYPE) -> PackedScene:
	var retrieved = GameContent.ENEMYSCENES[enemy_type]
	return retrieved
