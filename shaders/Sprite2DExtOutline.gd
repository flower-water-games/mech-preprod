extends Node

@export var ShaderColor: Vector4 = Vector4(0, 0, 0, 1)
@export var ShaderWidth: float = 10.0
@export var ShaderPattern: int = 0
@export var ShaderInside: bool = true
@export var ShaderAddMargins: bool = false

func _ready():
	var parent = get_parent()
	if parent is Sprite2D:
		var shaderRes = load("res://shaders/OutlineShader.tres") as ShaderMaterial
		shaderRes.set_shader_parameter("color", ShaderColor)
		shaderRes.set_shader_parameter("width", ShaderWidth)
		shaderRes.set_shader_parameter("pattern", ShaderPattern)
		shaderRes.set_shader_parameter("inside", ShaderInside)
		shaderRes.set_shader_parameter("add_margins", ShaderAddMargins)
		parent.material = shaderRes

