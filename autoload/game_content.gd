extends Node

'''
Preload assets for performance
'''

func _ready():
	_init_game_content()

var Bomb: PackedScene
var BombTargetSc: PackedScene
var BombBlast: PackedScene

func _init_game_content():
	Bomb = preload("res://scenes/GameScene/Enemy/Projectile/bomb.tscn")
	BombTargetSc = preload("res://scenes/GameScene/Enemy/Projectile/bomb_target.tscn")
	BombBlast = preload("res://scenes/GameScene/Enemy/Projectile/bomb_explode.tscn")
