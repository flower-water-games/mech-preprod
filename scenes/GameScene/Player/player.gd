extends CharacterBody2D
class_name Player

# Physics
const MAX_SPEED : float = 200
const ACCELERATION : float = 1000
const SHOOTING_SPEED_MULTIPLIER : float = 0.1

var motion : Vector2 = Vector2.ZERO
var facing_right : bool = true

@onready var health : Health = $Health
@onready var gun : Gun = $Shoot/Gun  # Assuming the Gun is a child node of the player

# Initialize
func _ready():
	add_to_group("Player")
	health.died.connect(player_died)
	$Mech/AnimationPlayer.play("idle")

func player_died():
	# queue_free()
	pass

# Called every frame
func _physics_process(delta):
	var axis = get_input_axis()
	# ternary vibes https://forum.godotengine.org/t/alternative-to-the-ternary-operator-in-gdscript/40160/3?u=carlosmichael
	var speed_multiplier = SHOOTING_SPEED_MULTIPLIER if gun.is_currently_shooting() else 1.0

	# If the player is not providing input
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else: # Otherwise move
		facing_right = true if (axis.x > 0) else false
		apply_movement(axis * ACCELERATION * delta * speed_multiplier)

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
