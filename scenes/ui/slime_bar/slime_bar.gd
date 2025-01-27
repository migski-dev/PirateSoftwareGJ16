extends TextureProgressBar

@export var player: Player 


func _ready() -> void:
	call_deferred("_connect_to_health") # idk if this is correct
	
	
func _connect_to_health():
	player.slime_health.health_changed.connect(_set_slime_value)
	_set_slime_value()

	
func _set_slime_value() -> void:
	value = player.slime_health.current_health
	
	

		
