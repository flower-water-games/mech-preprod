extends ShapeCast2D

@export var AP: AnimationPlayer
var _collision_max_radius = 47 #Radius times max scale
var _max_damage = 10

func _ready():
	AP.play("play")
	AP.animation_finished.connect(_playanim_end)

func _physics_process(delta):
	if is_colliding():
		_process_collision()

func _process_collision():
	# Assumption, only ever one player object
	var collision_count = get_collision_count()
	var collider = get_collider(0)
	if collider.is_in_group("Player"):
		collision_mask = 0
		var dist = global_position.distance_to(collider.global_position)
		var percent_damage = 1 - (dist/_collision_max_radius)
		var calc_damage = clamp(_max_damage * percent_damage, 0, _max_damage)
		print("Calcualted damage: " + str(calc_damage))
		collider.health.add_or_subtract_health_by_value(-calc_damage)

func _playanim_end(animation_name):
	if (animation_name == "play"):
		_cleanup()

func _cleanup():
	queue_free()
