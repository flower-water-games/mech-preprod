extends Node2D
class_name BombTarget

@export var AP: AnimationPlayer
@export var ASP: AudioStreamPlayer

var _player_instance: Player
var _target_lock = true

#region Public Functions

func disable_targeting():
	_target_lock = false
	play_random_sound(GameContent.lockon_sounds)
	AP.play("lock")

func destroy():
	_cleanup()

#endregion

func _ready():
	AP.play("idle")
	_player_instance = get_tree().get_first_node_in_group("Player")
	play_random_sound(GameContent.locking_sounds)
	if (!_player_instance):
		_cleanup()

func _process(_delta):
	if _target_lock:
		global_position = _player_instance.global_position

func _cleanup():
	queue_free()

#region SFX

func play_random_sound(sound_array: Array[AudioStream]):
	var random_index = randi() % sound_array.size()
	ASP.stream = sound_array[random_index]
	ASP.play()

#endregion
