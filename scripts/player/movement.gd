extends CharacterBody2D
class_name Movement

# Physics
const MAX_SPEED : float = 500
const ACCELERATION : float = 2000

var motion : Vector2 = Vector2.ZERO # Equaliant to Vector2(0,0)
var facing_right : bool = true

@onready var health : Health = $Health

# Initialize
func _ready():
	add_to_group("Player")
	Spawning.bullet_collided_body.connect(bullet_collided)
	health.died.connect(player_died)

func player_died():
	# queue_free()
	pass

func bullet_collided(body:Node,body_shape_index:int, bullet:Dictionary, local_shape_index:int,shared_area:Area2D):
	# Your custom code here
	if (body.collision_layer == 1):
		health.add_or_subtract_health_by_value(-bullet.props.damage)
	pass # Replace with function body.

# Called every frame
func _physics_process(delta):
	var axis = get_input_axis()
	# If the player is not providing input
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else: # Otherwise move
		facing_right = true if (axis.x > 0) else false
		apply_movement(axis * ACCELERATION * delta)
	# Apply the motion
	velocity = motion
	# Move to the position unless it hits a collision then it will stop at the collision point
	move_and_slide()

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO
		
func apply_movement(acceleration):
	motion += acceleration
	if motion.length() > MAX_SPEED:
		motion = motion.normalized() * MAX_SPEED
