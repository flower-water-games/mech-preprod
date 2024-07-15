extends Sprite2D

@export var AP: AnimationPlayer

func _ready():
	AP.play("play")
	AP.animation_finished.connect(_playanim_end)

func _playanim_end(animation_name):
	if (animation_name == "play"):
		_cleanup()

func _cleanup():
	queue_free()
