extends Node
class_name GameManager

@export var win_scene: PackedScene
@export var lose_scene: PackedScene

@onready var player: Movement = get_node("/root/MainGameScene/World2D/Player/Body")
@onready var enemy_factory: EnemyFactory = get_node("/root/MainGameScene/Services/EnemyFactory")
@onready var scroll_manager: ScrollManager = get_node("/root/MainGameScene/Services/ScrollManager")
@onready var label: Label = get_node("/root/MainGameScene/CanvasLayer/Label")
@onready var spawn_point : Node2D = get_node("/root/MainGameScene/World2D/SpawnPoint")

# spawn waves based on a diffulty threshold, can spawn multiple different types of enemies per waves
var waves = [
	{
		"difficulty_threshold": 0.0,
		"enemies": [
			{"type": EnemyFactory.EnemyType.WEAK, "base_spawn_rate": 1.5, "base_spawn_count": 20},
			{"type": EnemyFactory.EnemyType.NORMAL, "base_spawn_rate": .1, "base_spawn_count": 10},
		]
	},
	{
		"difficulty_threshold": 0.3,
		"enemies": [
			{"type": EnemyFactory.EnemyType.WEAK, "base_spawn_rate": 0.4, "base_spawn_count": 3},
			{"type": EnemyFactory.EnemyType.NORMAL, "base_spawn_rate": .1, "base_spawn_count": 10},
		]
	},
	{
		"difficulty_threshold": 0.7,
		"enemies": [
			{"type": EnemyFactory.EnemyType.WEAK, "base_spawn_rate": 0.3, "base_spawn_count": 4},
			{"type": EnemyFactory.EnemyType.WEAK, "base_spawn_rate": 1.3, "base_spawn_count": 20},
			{"type": EnemyFactory.EnemyType.NORMAL, "base_spawn_rate": 0.1, "base_spawn_count": 40},
		]
	},
	{
		"difficulty_threshold": 0.8,
		"enemies": [
			{"type": EnemyFactory.EnemyType.WEAK, "base_spawn_rate": .2, "base_spawn_count": 10},
			{"type": EnemyFactory.EnemyType.NORMAL, "base_spawn_rate": 0.3, "base_spawn_count": 40},
		]
	}
]

var current_wave_index = 0
var spawned_waves :Array[int]= []
var waiting_for_all_enemies_dead = false
var is_spawning = false

var player_score = 0

signal spawning_completed
signal new_wave_spawned

func _ready():
	await player.ready
	player.health.died.connect(_on_game_lost)
	await scroll_manager.ready
	scroll_manager.scroll_completed.connect(_on_scroll_completed)
	new_wave_spawned.connect(_cross_checkpoint)

func _process(_delta: float) -> void:
	if waiting_for_all_enemies_dead:
		if !are_enemies_alive():
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

func _cross_checkpoint():
	player.health.add_or_subtract_health_by_value(40)

func update_current_wave(difficulty: float) -> void:
	for i in range(waves.size()):
		if difficulty >= waves[i].difficulty_threshold and i not in spawned_waves:
			current_wave_index = i
			# heal checkpoint
			return
# 
func spawn_wave(wave_index: int) -> void:
	if wave_index in spawned_waves:
		return
	
	new_wave_spawned.emit()
	is_spawning = true
	var wave = waves[wave_index]
	for enemy_config in wave.enemies:
		spawn_enemy_group(enemy_config)
	spawned_waves.append(wave_index)
	is_spawning = false
	print("Completed spawning wave: ", wave_index)

func update_ui():
	label.text = "Progress: %d%% | Wave: %d" % [int(scroll_manager.get_raw_progress() * 100), current_wave_index + 1]

func _on_game_lost():
	InGameMenuController.open_menu(lose_scene, get_viewport())

func _on_game_won():
	InGameMenuController.open_menu(win_scene, get_viewport())

func spawn_enemy_group(enemy_config: Dictionary) -> void:
	var spawn_task = func():
		for i in range(enemy_config.base_spawn_count):
			var e = enemy_factory.create_enemy(enemy_config.type)
			spawn_point.add_child(e)
			await get_tree().create_timer(enemy_config.base_spawn_rate).timeout
		print("Completed spawning enemy type: ", enemy_config.type)

	# Start the spawning task without waiting for it to complete
	spawn_task.call_deferred()

## Checks the spawn point for any active children
func are_enemies_alive() -> bool:
	return spawn_point.get_child_count() > 0

func get_enemy_count() -> int:
	return spawn_point.get_child_count()