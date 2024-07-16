extends Node2D

@export var remote_foot_target : Node2D

@onready var shin : Sprite2D = $Shin

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shin.rotation = shin.global_position.angle_to_point(remote_foot_target.foot.global_position)
