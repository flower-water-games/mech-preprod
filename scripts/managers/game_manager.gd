extends Node

@export var win_scene : PackedScene
@export var lose_scene : PackedScene

# all global paths
@onready var player : Movement = get_node("/root/MainGameScene/World2D/Player/Body")
@onready var enemy_factory : EnemyFactory = get_node("/root/MainGameScene/Services/EnemyFactory")
@onready var scroll_manager : ScrollManager = get_node("/root/MainGameScene/Services/ScrollManager")
@onready var label : Label = get_node("/root/MainGameScene/CanvasLayer/Label")
@onready var main_game = get_node("/root/MainGameScene")

var current_difficulty := 0.0
# iterate through the array, based on 0-1. could be better ways to do this / #TODO import from json
const SPAWN_CONFIGS = [
	[{
			"type" : EnemyFactory.EnemyType.WEAK,
			"spawn_rate": 4.0,
			"spawn_count": 3
	}],
	[{
			"type":EnemyFactory.EnemyType.WEAK,
			"spawn_rate": 4.0,
			"spawn_count": 9
		},
		{
			"type":EnemyFactory.EnemyType.NORMAL,
			"spawn_rate": 3.0,
			"spawn_count": 4
		}
	],
	[{
			"type":EnemyFactory.EnemyType.WEAK,
			"spawn_rate": 4.0,
			"spawn_count": 9
		},
		{
			"type":EnemyFactory.EnemyType.NORMAL,
			"spawn_rate": 4.0,
			"spawn_count": 2
		}
	]
]

func _ready():
	Spawning.reset()
	InGameMenuController.scene_tree = get_tree()
	await player.ready
	_register_player()
	scroll_manager.scroll_completed.connect(_on_game_won)
	Spawning.create_pool("one", "0", 1000)
	Spawning.create_pool("two", "1", 1000)


var current_spawn_config := []

var time_since_last_update = 1.0
var update_time = 1.0
func _process(delta: float) -> void:

	time_since_last_update += delta
	if (time_since_last_update >= update_time):
		# get the current difficulty, 0-1
		current_difficulty = scroll_manager.get_difficulty()
		# get the old config to compare if its changed
		var old_config = current_spawn_config
		# if the index has changed based on the difficulty, spawn the new enemies
		current_spawn_config = _get_spawn_config(current_difficulty)
		if (old_config != current_spawn_config):
			# temp, just spawns all the enemies immediately
			spawn_enemies(current_spawn_config)
		_update_ui()
		time_since_last_update = 0.0

func spawn_enemies(data:Array) -> void:
	for e in range(data.size()):
		for i in range(data[e]["spawn_count"]):
			enemy_factory.create_enemy(data[e]["type"])
			await get_tree().create_timer(data[e]["spawn_rate"]).timeout

func _update_ui():
	var index := int(current_difficulty * SPAWN_CONFIGS.size() - 1)
	index = clamp(index, 0, SPAWN_CONFIGS.size()-1)
	label.text = str(int(scroll_manager.get_raw_progress() * 100))+"%"


func _get_spawn_config(difficulty: float) -> Array: 
	# map difficulty to the size of the array
	var index := int(difficulty * SPAWN_CONFIGS.size() - 1)
	index = clamp(index, 0, SPAWN_CONFIGS.size() - 1)
	return SPAWN_CONFIGS[index]

func _register_player():
	player.health.died.connect(_on_game_lost)


func _on_game_lost():
	InGameMenuController.open_menu(lose_scene, get_viewport())


func _on_game_won():
	InGameMenuController.open_menu(win_scene, get_viewport())
