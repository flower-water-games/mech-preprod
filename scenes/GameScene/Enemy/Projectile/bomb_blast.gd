extends CharacterBody2D

@export var AP: AnimationPlayer
var _collision_max_radius = 47 #Radius times max scale
var _max_damage = 50

func _ready():
	AP.play("play")
	AP.animation_finished.connect(_playanim_end)
	velocity = Vector2(0, 0)

func _physics_process(delta):
	if collision_mask == 0:
		return
	var col = move_and_collide(velocity * delta)
	if (col):
		_process_collision(col)

func _process_collision(col : KinematicCollision2D):
	var collider : Node2D = col.get_collider()
	if collider.is_in_group("Player"):
		collision_mask = 0
		var dist = global_position.distance_to(collider.global_position)
		var percent_damage = 1 - (dist/_collision_max_radius)
		var calc_damage = clamp(_max_damage * percent_damage, 0, _max_damage)
		collider.health.add_or_subtract_health_by_value(-calc_damage)

func _playanim_end(animation_name):
	if (animation_name == "play"):
		_cleanup()

func _cleanup():
	queue_free()
