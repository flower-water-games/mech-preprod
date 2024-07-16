extends Node

'''
Preload assets for performance
'''

func _ready():
	_init_game_content()

var Bomb: PackedScene
var BombTargetSc: PackedScene
var BombBlast: PackedScene
var FXEnemyExplode: PackedScene
# Sound effect variables
var explosion_sounds: Array[AudioStream] = []
var gatling_bullet_sounds: Array[AudioStream] = []
var ui_sounds: Array[AudioStream] = []
var bombthrow_sounds: Array[AudioStream] = []
var lockon_sounds: Array[AudioStream] = []
var level_track: AudioStream


func _init_game_content():
	Bomb = preload("res://scenes/GameScene/Enemy/Projectile/bomb.tscn")
	BombTargetSc = preload("res://scenes/GameScene/Enemy/Projectile/bomb_target.tscn")
	BombBlast = preload("res://scenes/GameScene/Enemy/Projectile/bomb_explode.tscn")

	FXEnemyExplode = preload("res://scenes/GameScene/Components/Onetime Animations/enemy_explosion.tscn")

	## sound effects
	explosion_sounds.append(load("res://assets/audio/OGG Deliveries/explosions.ogg"))
	for i in range(1, 6):  
		explosion_sounds.append(load("res://assets/audio/OGG Deliveries/explosions_" + str(i) + ".ogg"))
	
	gatling_bullet_sounds.append(load("res://assets/audio/OGG Deliveries/GattlingBullets.ogg"))
	for i in range(1, 9):  
		gatling_bullet_sounds.append(load("res://assets/audio/OGG Deliveries/GattlingBullets_" + str(i) + ".ogg"))
	
	bombthrow_sounds.append(load("res://assets/audio/OGG Deliveries/bombthrow.ogg"))
	for i in range(1, 3):  
		bombthrow_sounds.append(load("res://assets/audio/OGG Deliveries/bombthrow_" + str(i) + ".ogg"))
	
	lockon_sounds.append(load("res://assets/audio/OGG Deliveries/Lockon.ogg"))
	for i in range(1, 3):  
		lockon_sounds.append(load("res://assets/audio/OGG Deliveries/Lockon_" + str(i) + ".ogg"))
	
	# Load the level track
	level_track = load("res://assets/audio/OGG Deliveries/leveltracktrueloop.ogg")