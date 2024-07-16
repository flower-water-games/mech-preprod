@tool
extends Node2D

@onready var foot_target : Node2D

@onready var thigh : Bone2D = $Skeleton2D/Thigh
@onready var knee : Bone2D = $Skeleton2D/Thigh/Knee
@onready var foot : Bone2D = $Skeleton2D/Thigh/Knee/Foot

@onready var line_2d : Line2D = $Line2D

func _ready():
	pass

func _process(delta):
	line_2d.clear_points()
	line_2d.add_point(thigh.global_position)
	line_2d.add_point(knee.global_position)
	line_2d.add_point(foot.global_position)
