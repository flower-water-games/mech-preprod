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
var bomb_target: BombTarget

func _ready():
	_create_target_lock()
	AP.play("throw")
	AP.animation_finished.connect(_bomb_anim_finished)
	if (is_instance_valid(bomb_target)):
		bomb_target.disable_targeting()

func _physics_process(delta):
	PhysicsObj.move_and_collide(PhysicsObj.velocity * delta)

func _create_target_lock():
	if (is_instance_valid(bomb_target)):
		var bomb_dir = position.direction_to(bomb_target.position)
		var dist = position.distance_to(bomb_target.position)
		var bomb_spd = dist
		PhysicsObj.velocity = bomb_dir * bomb_spd

func _bomb_anim_finished(animation_name):
	if animation_name == "throw":
		var explosion = GameContent.BombBlast.instantiate()
		add_sibling(explosion)
		explosion.global_position = PhysicsObj.global_position
		_cleanup()

func _cleanup():
	if is_instance_valid(bomb_target):
		bomb_target.queue_free()
	queue_free()
