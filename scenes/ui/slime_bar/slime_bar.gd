extends TextureProgressBar

@export var player: Player 


func _ready() -> void:
	GameEvents.on_range_start.connect(_on_range_start)
	call_deferred("_connect_to_health") # idk if this is correct
	
	
func _connect_to_health():
	player.slime_health.health_changed.connect(_set_slime_value)
	_set_slime_value()

func _on_range_start(range_cost: float) -> void:
	player.slime_health.damage(range_cost)
	
	
func _set_slime_value() -> void:
	value = player.slime_health.current_health
	
	
func check_slime_size() -> void:
	if value >= 70 and not (player.current_size_state == player.large_size_state):
		GameEvents.on_transition_to_large.emit()
	elif value < 70 and value > 30 and not (player.current_size_state == player.medium_size_state):
		GameEvents.on_transition_to_medium.emit()
	elif value <= 30 and not (player.current_size_state == player.small_size_state):
		GameEvents.on_transition_to_small.emit()
		
