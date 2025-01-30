extends Sprite2D
@export var rotation_point: Marker2D

func _ready():
	hide()

func _process(delta):
	var mouse_position: Vector2 = get_global_mouse_position()
	look_at(mouse_position)
	
