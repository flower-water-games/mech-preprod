extends Polygon2D
class_name SpawnRectangle

# Points are ordered from math quadrants 2, 3, 4, 1

func get_spawn_point():
	var topLeft = to_global(polygon[0])
	var bottomRight = to_global(polygon[2])
	var randomX = randi_range(0, bottomRight.x - topLeft.x)
	var randomY = randi_range(0, bottomRight.y - topLeft.y)
	var ranVector = Vector2(randomX, randomY)
	var result = topLeft + ranVector
	return result
