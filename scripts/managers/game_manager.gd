extends Node
class_name GameManager

#region Properties

@export var win_scene: PackedScene
@export var lose_scene: PackedScene

# core services nodes
@onready var player: Player = get_node("/root/MainGameScene/World2D/Player/Body")
@onready var player_gun: Gun = get_node("/root/MainGameScene/World2D/Player/Body/MechRig/Gun")
@onready var player_gun2: Gun = get_node("/root/MainGameScene/World2D/Player/Body/MechRig/Gun2")
@onready var player_cursor: Cursor = get_node("/root/MainGameScene/World2D/Player/Body/MechRig/Cursor")
@onready var enemy_factory: EnemyFactory = get_node("/root/MainGameScene/Services/EnemyFactory")
@onready var bullet_factory: BulletFactory = get_node("/root/MainGameScene/Services/BulletFactory")
@onready var scroll_manager: ScrollManager = get_node("/root/MainGameScene/Services/ScrollManager")
@onready var label: Label = get_node("/root/MainGameScene/CanvasLayer/Label")
@onready var score: Label = get_node("/root/MainGameScene/CanvasLayer/Score")

# spawning
@onready var spawn_point : Node2D = get_node("/root/MainGameScene/World2D/SpawnPoint/Enemies")
@onready var bullet_spawn = get_node("/root/MainGameScene")

# simple audio node stuff (will be updated w a proper sfx manager)
# @onready var death_sfx : AudioStreamPlayer = get_node("/root/MainGameScene/Services/SFXManager/AudioStreamPlayer")
# @onready var shoot_sfx : AudioStreamPlayer = get_node("/root/MainGameScene/Services/SFXManager/AudioStreamPlayer2")
@onready var sfx_player : AudioStreamPlayer = get_node("/root/MainGameScene/Services/SFXPlayer")

# state variables for waves, keep track of current wave and previously spawned waves
var current_wave_index = 0
var spawned_waves :Array[int]= []
var waiting_for_all_enemies_dead = false
var is_spawning = false

var player_score = 0
var hi_score = GameContent.getHiScore()

# signals
signal spawning_completed
signal new_wave_spawned

#endregion

#region Init and Main

func _ready():
	await player.ready
	player.health.died.connect(_on_game_lost)
	player_gun.gun_shot.connect(_player_shoot)
	player_gun2.gun_shot.connect(_player_shoot)
	scroll_manager.scroll_completed.connect(_on_scroll_completed)
	#new_wave_spawned.connect(_cross_checkpoint)

func _process(_delta: float) -> void:
	# current "end state" condition - when all waves are spawned, just clear the screen to trigger the end
	if waiting_for_all_enemies_dead:
		if !are_enemies_alive():
			_on_game_won()
	else:
		# core game loop
		# 1. get the current difficulty
		# 2. check if a new wave exists that meets its threshold
		# 3. if so, spawn it
		var difficulty = scroll_manager.get_difficulty()
		update_current_wave(difficulty)
		if !is_spawning:
			spawn_wave(current_wave_index)
	update_ui()

#endregion

#region Game Manager

## when we've reached scroll zero, stop spawning, and wait until all enemies are dead
func _on_scroll_completed():
	waiting_for_all_enemies_dead = true
	spawning_completed.emit()

## triggers crossing a checkpoint functionality
func _cross_checkpoint():
	#player.health.add_or_subtract_health_by_value(10)
	pass

func update_ui():
	label.text = "Revolution Momentum %d%%" % [int(scroll_manager.get_raw_progress() * 100)]
	score.text = "Score: %d HiScore: %d" % [player_score, hi_score]

func _on_game_lost():
	GameContent.updateHiScore(player_score)
	InGameMenuController.open_menu(lose_scene, get_viewport())

func _on_game_won():
	InGameMenuController.open_menu(win_scene, get_viewport())

func _add_score(value:int)->void:
	player_score+=value

#endregion

#region Player

func _player_shoot(inputpos : Vector2):
	var b = bullet_factory.create_bullet(BulletFactory.BulletType.PLAYER_BULLET)
	b.position = inputpos

	var sourcePos = inputpos
	var targetPos = player_cursor.global_position
	b.bullet_dir = sourcePos.direction_to(targetPos)
	b.rotation = sourcePos.angle_to_point(targetPos)

	bullet_spawn.add_child(b)
	play_random_sound(GameContent.gatling_bullet_sounds)

#endregion

#region Enemies

## Checks the spawn point for any active children

func update_current_wave(difficulty: float) -> void:
	for i in range(waves.size()):
		if difficulty >= waves[i].progress and i not in spawned_waves:
			current_wave_index = i
			new_wave_spawned.emit()
			return

func spawn_wave(wave_index: int) -> void:
	if wave_index in spawned_waves:
		return

	is_spawning = true
	var wave = waves[wave_index]
	for spawngroup in wave.spawngroup:
		spawn_enemy_group(spawngroup, wave_index)
	spawned_waves.append(wave_index)
	is_spawning = false

func spawn_enemy_group(spawngroup: Dictionary, wave_index: int):
	var loc = spawngroup.location
	var enemies = spawngroup.enemies
	for enemy in enemies:
		var spawn_task = func():
			var this_wave_index = wave_index
			for i in range(enemy.base_spawn_count):
				if current_wave_index > this_wave_index:
					break
				var e : Enemy = enemy_factory.create_enemy(enemy.type, loc)
				e.enemy_died.connect(_add_score.bind(e.score))
				e.enemy_died.connect(play_random_sound_player.bind(e.sfx_player, GameContent.explosion_sounds))
				await get_tree().create_timer(enemy.base_spawn_rate).timeout
		spawn_task.call_deferred()

func are_enemies_alive() -> bool:
	return get_enemy_count() > 0

func get_enemy_count() -> int:
	return spawn_point.get_child_count()

#endregion

func play_random_sound_player(player : AudioStreamPlayer, sound_array: Array[AudioStream]):
	var random_index = randi() % sound_array.size()
	player.stream = sound_array[random_index]
	player.play()

func play_random_sound(sound_array: Array[AudioStream]):
	var random_index = randi() % sound_array.size()
	sfx_player.stream = sound_array[random_index]
	sfx_player.play()

#region Wave Setup

var waves = [
	{
		"progress": 0,
		"spawngroup": [
			{
				"location": GameContent.SPAWNLOC.Top,
				"enemies": [
					{"type": GameContent.ENEMYTYPE.Bot, "base_spawn_rate": 0.5, "base_spawn_count": 5000},
					{"type": GameContent.ENEMYTYPE.Bomber, "base_spawn_rate": 3, "base_spawn_count": 5000},
				]
			},
			{
				"location": GameContent.SPAWNLOC.Middle,
				"enemies": [
					{"type": GameContent.ENEMYTYPE.Bot, "base_spawn_rate": 0.75, "base_spawn_count": 5000},
					{"type": GameContent.ENEMYTYPE.Bomber, "base_spawn_rate": 5, "base_spawn_count": 5000},
				]
			},
			{
				"location": GameContent.SPAWNLOC.Bottom,
				"enemies": [
					{"type": GameContent.ENEMYTYPE.Bot, "base_spawn_rate": 1, "base_spawn_count": 5000},
					{"type": GameContent.ENEMYTYPE.Bomber, "base_spawn_rate": 5, "base_spawn_count": 5000},
				]
			},
		]
	},
	{
		"progress": 25,
		"spawngroup": [
			{
				"location": GameContent.SPAWNLOC.Top,
				"enemies": [
					{"type": GameContent.ENEMYTYPE.Bot, "base_spawn_rate": 1, "base_spawn_count": 5000},
					{"type": GameContent.ENEMYTYPE.Bomber, "base_spawn_rate": 5, "base_spawn_count": 5000},
				]
			},
			{
				"location": GameContent.SPAWNLOC.Middle,
				"enemies": [
					{"type": GameContent.ENEMYTYPE.Bot, "base_spawn_rate": 0.75, "base_spawn_count": 5000},
					{"type": GameContent.ENEMYTYPE.Bomber, "base_spawn_rate": 5, "base_spawn_count": 5000},
				]
			},
			{
				"location": GameContent.SPAWNLOC.Bottom,
				"enemies": [
					{"type": GameContent.ENEMYTYPE.Bot, "base_spawn_rate": 0.5, "base_spawn_count": 5000},
					{"type": GameContent.ENEMYTYPE.Bomber, "base_spawn_rate": 3, "base_spawn_count": 5000},
				]
			},
		]
	},
	{
		"progress": 50,
		"spawngroup": [
			{
				"location": GameContent.SPAWNLOC.Top,
				"enemies": [
					{"type": GameContent.ENEMYTYPE.Bot, "base_spawn_rate": 0.5, "base_spawn_count": 5000},
					{"type": GameContent.ENEMYTYPE.Bomber, "base_spawn_rate": 3, "base_spawn_count": 5000},
				]
			},
			{
				"location": GameContent.SPAWNLOC.Middle,
				"enemies": [
					{"type": GameContent.ENEMYTYPE.Bot, "base_spawn_rate": 1, "base_spawn_count": 5000},
					{"type": GameContent.ENEMYTYPE.Bomber, "base_spawn_rate": 5, "base_spawn_count": 5000},
				]
			},
			{
				"location": GameContent.SPAWNLOC.Bottom,
				"enemies": [
					{"type": GameContent.ENEMYTYPE.Bot, "base_spawn_rate": 0.75, "base_spawn_count": 5000},
					{"type": GameContent.ENEMYTYPE.Bomber, "base_spawn_rate": 5, "base_spawn_count": 5000},
				]
			},
		]
	},
]

#endregion
