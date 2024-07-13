extends ParallaxLayer

@export var HSpeed : float = -100
var Multiplier: float = 1.0

func _process(delta):
	self.motion_offset.x += HSpeed * Multiplier * delta
