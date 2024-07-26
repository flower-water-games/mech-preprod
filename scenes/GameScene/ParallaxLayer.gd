extends ParallaxLayer

@export var HSpeed : float = -100
var Multiplier: float = 1.0
@onready var scroll_manager : ScrollManager= get_node("/root/MainGameScene/Services/ScrollManager")

func _process(delta):
	self.motion_offset.x += HSpeed * scroll_manager.get_current_difficulty() * delta
