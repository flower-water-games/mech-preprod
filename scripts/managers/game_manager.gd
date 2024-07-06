extends Node
class_name GameManager

@export var win_scene: PackedScene
@export var lose_scene: PackedScene

@onready var player: Movement = get_node("/root/MainGameScene/World2D/Player/Body")
@onready var enemy_factory: EnemyFactory = get_node("/root/MainGameScene/Services/EnemyFactory")
@onready var scroll_manager: ScrollManager = get_node("/root/MainGameScene/Services/ScrollManager")
@onready var label: Label = get_node("/root/MainGameScene/CanvasLayer/Label")
# spawn waves based on a diffulty threshold, can spawn multiple different types of enemies per waves
var waves = [
	{
		"difficulty_threshold": 0.0,
		"enemies": [
			{"type": EnemyFactory.EnemyType.WEAK, "base_spawn_rate": 0.5, "base_spawn_count": 2},
			{"type": EnemyFactory.EnemyType.NORMAL, "base_spawn_rate": .1, "base_spawn_count": 10},
		]
	},
	{
		"difficulty_threshold": 0.3,
		"enemies": [
			{"type": EnemyFactory.EnemyType.WEAK, "base_spawn_rate": 0.4, "base_spawn_count": 3},
		]
	},
	{
		"difficulty_threshold": 0.6,
		"enemies": [
			{"type": EnemyFactory.EnemyType.WEAK, "base_spawn_rate": 0.3, "base_spawn_count": 4},
			{"type": EnemyFactory.EnemyType.WEAK, "base_spawn_rate": 0.3, "base_spawn_count": 4},
		]
	},
	{
		"difficulty_threshold": 0.9,
		"enemies": [
			{"type": EnemyFactory.EnemyType.STRONG, "base_spawn_rate": 1.0, "base_spawn_count": 1},
		]
	}
]

var current_wave_index = 0
var spawned_waves :Array[int]= []
var waiting_for_all_enemies_dead = false
var is_spawning = false

var player_score = 0

signal spawning_completed

func _ready():
	await player.ready
	player.health.died.connect(_on_game_lost)
	scroll_manager.scroll_completed.connect(_on_scroll_completed)

func _process(_delta: float) -> void:
	if waiting_for_all_enemies_dead:
		if !enemy_factory.are_enemies_alive():
			_on_game_won()
	else: 
		var difficulty = scroll_manager.get_difficulty()
		update_current_wave(difficulty)
		if !is_spawning:
			spawn_wave(current_wave_index)
	
	update_ui()

func _on_scroll_completed():
	waiting_for_all_enemies_dead = true
	spawning_completed.emit()

func update_current_wave(difficulty: float) -> void:
	for i in range(waves.size()):
		if difficulty >= waves[i].difficulty_threshold and i not in spawned_waves:
			current_wave_index = i
			return
# 
func spawn_wave(wave_index: int) -> void:
	if wave_index in spawned_waves:
		return
	
	is_spawning = true

	var wave = waves[wave_index]
	for enemy_config in wave.enemies:
		for i in range(enemy_config.base_spawn_count):
			enemy_factory.create_enemy(enemy_config.type)
			await get_tree().create_timer(enemy_config.base_spawn_rate).timeout
	
	spawned_waves.append(wave_index)
	is_spawning = false
	print("Completed spawning wave: ", wave_index)

func update_ui():
	label.text = "Progress: %d%% | Wave: %d" % [int(scroll_manager.get_raw_progress() * 100), current_wave_index + 1]

func _on_game_lost():
	InGameMenuController.open_menu(lose_scene, get_viewport())

func _on_game_won():
	InGameMenuController.open_menu(win_scene, get_viewport())