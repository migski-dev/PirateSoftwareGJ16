extends TextureProgressBar

@export var player: Player 

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.on_range_start.connect(_on_range_start)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = player.slime_health.current_health

func _on_range_start(range_cost: float) -> void:
	player.slime_health.damage(range_cost)
	
func check_slime_size() -> void:
	if value >= 70 and not (player.current_size_state == player.large_size_state):
		GameEvents.on_transition_to_large.emit()
	elif value < 70 and value > 30 and not (player.current_size_state == player.medium_size_state):
		GameEvents.on_transition_to_medium.emit()
	elif value <= 30 and not (player.current_size_state == player.small_size_state):
		GameEvents.on_transition_to_small.emit()
		
