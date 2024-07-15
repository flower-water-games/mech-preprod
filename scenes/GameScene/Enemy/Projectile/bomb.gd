extends Node2D

"""
Algorithm:
	Upon spawning, locates a targetting object. If none exists, cleanup.
	Otherwise, calculate the speed required to send the projectile to
	the target location in one second.
	At the end of the animation (which is one second), spawn an explosion
	object which can damage the player.
"""

@export var AP: AnimationPlayer
@export var PhysicsObj: CharacterBody2D
var bomb_target: Vector2 = position

func _ready():
	_create_target_lock()
	AP.play("throw")
	AP.animation_finished.connect(_bomb_anim_finished)

func _process(delta):
	pass

func _create_target_lock():
	#var dir_vector = get_angle_to(bomb_target.position)
	pass

func _bomb_anim_finished(animation_name):
	if animation_name == "throw":
		_cleanup()

func _cleanup():
	queue_free()
