extends Node2D
class_name BombTarget

@export var AP: AnimationPlayer

var _player_instance: Player
var _target_lock = true

#region Public Functions

func disable_targeting():
	_target_lock = false
	AP.play("lock")

func destroy():
	_cleanup()

#endregion

func _ready():
	AP.play("idle")
	_player_instance = get_tree().get_first_node_in_group("Player")
	if (!_player_instance):
		_cleanup()

func _process(delta):
	if _target_lock:
		global_position = _player_instance.global_position

func _cleanup():
	queue_free()
