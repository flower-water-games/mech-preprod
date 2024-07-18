extends Sprite2D

var velocity: Vector2
var gravity: float = 980  # Adjust this value to change gravity strength
var lifetime: float = 0.3  # Lifetime in seconds
var spin_speed: float  # Angular velocity for spinning

func _ready():
	# Set random initial velocity in -x, -y direction
	velocity = Vector2(
		randf_range(-200, -100),  # Adjust these ranges as needed
		randf_range(-200, -100)
	)
	
	self_modulate = Color(1.0, 1.0, 1.0).darkened(randf_range(0.0, 1.0))
	
	# Set a random initial rotation
	rotation = randf_range(-PI/4, PI/4)  # Random angle between -45 and 45 degrees
	
	# Set a random spin speed
	spin_speed = randf_range(-5, 5)  # Adjust this range for faster or slower spinning
	
	# Start the timer to delete the node after 1 second
	get_tree().create_timer(lifetime).connect("timeout", Callable(self, "queue_free"))

func _physics_process(delta):
	# Apply gravity
	velocity.y += gravity * delta
	
	# Move the sprite
	position += velocity * delta
	
	# Apply rotation
	rotation += spin_speed * delta
