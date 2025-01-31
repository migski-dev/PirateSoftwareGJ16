extends Camera2D

@export var random_strength: float = 10.0
@export var shake_fade: float = 5.0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func _ready() -> void:
	GameEvents.on_shake_camera.connect(_on_shake_camera)

func _on_shake_camera(shake_value:float) -> void:
	apply_shake(shake_value)
	
func apply_shake(shake_value: float):
	shake_strength = shake_value
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf( shake_strength, 0, shake_fade * delta)
		offset = random_offset()
		

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
