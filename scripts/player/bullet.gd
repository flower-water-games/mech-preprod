extends Area2D
class_name Bullet

@export var damage := 10.0
@export var velocity := Vector2.ZERO
@export var lifetime := 2.0

var timer := 0.0

func _ready() -> void:
	# Connect the body_entered signal to the on_body_entered function
	body_entered.connect(on_body_entered)

func _process(delta: float) -> void:
	# Move the bullet based on its velocity
	position += velocity * delta
	
	# Update the bullet's lifetime
	timer += delta
	if timer >= lifetime:
		queue_free()

func on_body_entered(body: Node) -> void:
	# Check if the bullet collided with a valid target (e.g., enemy or player)
	if body.has_method("take_damage"):
		# Call the take_damage function on the target
		body.take_damage(damage)
		
		# Destroy the bullet
		queue_free()
