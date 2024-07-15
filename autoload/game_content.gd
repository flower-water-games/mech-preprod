extends Node

'''
Preload assets for performance
'''

func _ready():
	_init_game_content()

var Bomb: PackedScene
var BombTarget: PackedScene
var SceneTest: PackedScene

func _init_game_content():
	Bomb = preload("res://scenes/GameScene/Enemy/Projectile/bomb.tscn")
	BombTarget = preload("res://scenes/GameScene/Enemy/Projectile/bomb_target.tscn")
	SceneTest = preload("res://scenes/GameScene/Enemy/bot_basic.tscn")
