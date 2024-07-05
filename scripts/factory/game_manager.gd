extends Node

@export var win_scene : PackedScene
@export var lose_scene : PackedScene
@onready var player : Movement = get_node("/root/MainGameScene/World2D/Player/Body")
@onready var enemy_factory : EnemyFactory = get_node("/root/MainGameScene/Services/EnemyFactory")

func _ready():
	InGameMenuController.scene_tree = get_tree()
	#TODO is this right? it works!
	await player.ready
	register_player()


func register_player():
	player.health.died.connect(_on_level_lost)


func _on_level_lost():
	InGameMenuController.open_menu(lose_scene, get_viewport())

func _on_level_won():
	InGameMenuController.open_menu(win_scene, get_viewport())

