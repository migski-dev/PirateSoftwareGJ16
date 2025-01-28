extends HealthComponent
class_name SlimeComponent

signal on_damage_shrink

@export var tinyThreshold: float = 1
@export var smallThreshold: float = 3
@export var mediumThreshold: float = 5
@export var largeThreshold: float = 10
@export var XLThreshold: float = 12

var player: Player

func _ready() -> void:
	current_health = max_health
	GameEvents.on_slime_pickup.connect(_on_slime_pickup)
	GameEvents.on_range_start.connect(damage)
	player = get_parent()
	
	
func damage(damage_amount: float):
	if player.is_invulnerable:
		return
	current_health = clamp(current_health - damage_amount, 0, max_health)
	health_changed.emit()
	set_slime_size()
	if damage_amount > 0:
		health_decreased.emit()
	Callable(check_death).call_deferred()
	
	
	
func _on_slime_pickup(slime_amount: int) -> void:
	heal(slime_amount)
	#set_slime_size()
	

# shrink down when current size is below the threshold
func set_slime_size() -> void:
	if (current_health < largeThreshold and current_health >= mediumThreshold 
		and [player.large_size_state].has(player.current_size_state) ):
		on_damage_shrink.emit()
		GameEvents.on_transition_to_medium.emit()
	elif (current_health < mediumThreshold and current_health >= smallThreshold 
		and [player.large_size_state, player.medium_size_state].has(player.current_size_state)):
		on_damage_shrink.emit()
		GameEvents.on_transition_to_small.emit()
	elif (current_health < smallThreshold and current_health > 0 
		and [player.large_size_state, player.medium_size_state, player.small_size_state].has(player.current_size_state)):
		on_damage_shrink.emit()
		GameEvents.on_transition_to_XS.emit()
	elif current_health == 0:
		GameEvents.on_player_died.emit()
