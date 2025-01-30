extends Sprite2D
@export var rotation_point: Marker2D

func _ready():
	hide()

func _process(delta):
	var mouse_position: Vector2 = get_global_mouse_position()
	look_at(mouse_position)
	var degrees_rotated: float = fmod(rotation_degrees, 360)
	if (degrees_rotated < 270 and degrees_rotated > 90):
		scale = Vector2(1, -1)
	else:
		scale = Vector2(1, 1)

	
