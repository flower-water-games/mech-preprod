extends Node

'''
Preload assets for performance
'''

func _ready():
	_init_game_content()

#region Global resources

var HighScore: int = 0
func updateHiScore(newScore):
	if newScore > HighScore:
		HighScore = newScore
		Config.set_config("Hiscore", "Hiscore", HighScore)

func getHiScore():
	return HighScore

var Bomb: PackedScene
var BombTargetSc: PackedScene
var BombBlast: PackedScene
var FXEnemyExplode: PackedScene

# Sound effect variables
var explosion_sounds: Array[AudioStream] = []
var gatling_bullet_sounds: Array[AudioStream] = []
var ui_sounds: Array[AudioStream] = []
var bombthrow_sounds: Array[AudioStream] = []
var locking_sounds: Array[AudioStream] = []
var lockon_sounds: Array[AudioStream] = []
var level_track: AudioStream

enum ENEMYTYPE {
	Bot,
	Bomber,
	Boss
}
var ENEMYSCENES = {
	ENEMYTYPE.Bot: PackedScene,
	ENEMYTYPE.Bomber: PackedScene,
	ENEMYTYPE.Boss: PackedScene,
}

#endregion

func _init_game_content():

	HighScore = Config.get_config("Hiscore", "Hiscore", 0)

	#region Packed Scenes

	ENEMYSCENES[ENEMYTYPE.Bot] = preload("res://scenes/GameScene/Enemy/bot_basic.tscn")
	ENEMYSCENES[ENEMYTYPE.Bomber] = preload("res://scenes/GameScene/Enemy/bot_bomber.tscn")
	ENEMYSCENES[ENEMYTYPE.Boss] = preload("res://scenes/GameScene/Enemy/bot_basic.tscn")
	Bomb = preload("res://scenes/GameScene/Enemy/Projectile/bomb.tscn")
	BombTargetSc = preload("res://scenes/GameScene/Enemy/Projectile/bomb_target.tscn")
	BombBlast = preload("res://scenes/GameScene/Enemy/Projectile/bomb_explode.tscn")
	FXEnemyExplode = preload("res://scenes/GameScene/Components/Onetime Animations/enemy_explosion.tscn")

	#endregion

	#region sound effects

	explosion_sounds.append(load("res://assets/audio/OGG Deliveries/explosions.ogg"))
	for i in range(1, 6):
		explosion_sounds.append(load("res://assets/audio/OGG Deliveries/explosions_" + str(i) + ".ogg"))

	gatling_bullet_sounds.append(load("res://assets/audio/OGG Deliveries/GattlingBullets.ogg"))
	for i in range(1, 9):
		gatling_bullet_sounds.append(load("res://assets/audio/OGG Deliveries/GattlingBullets_" + str(i) + ".ogg"))

	bombthrow_sounds.append(load("res://assets/audio/OGG Deliveries/bombthrow.ogg"))
	for i in range(1, 3):
		bombthrow_sounds.append(load("res://assets/audio/OGG Deliveries/bombthrow_" + str(i) + ".ogg"))

	locking_sounds.append(load("res://assets/audio/OGG Deliveries/locking.ogg"))
	lockon_sounds.append(load("res://assets/audio/OGG Deliveries/locked_on.ogg"))

	#endregion

	#region BGM

	# Load the level track
	level_track = load("res://assets/audio/OGG Deliveries/leveltracktrueloop.ogg")

	#endregion

#region Spawn Locations

enum SPAWNLOC {
	Top,
	Middle,
	Bottom
}
