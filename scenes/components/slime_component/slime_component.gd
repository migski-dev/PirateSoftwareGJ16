extends HealthComponent
class_name SlimeComponent

@export var tinyThreshold: float = 1
@export var smallThreshold: float = 3
@export var mediumThreshold: float = 5
@export var largeThreshold: float = 10
@export var XLThreshold: float = 12


func _ready() -> void:
	current_health = max_health
	GameEvents.on_slime_pickup.connect(_on_slime_pickup)
	GameEvents.on_range_start.connect(damage)
	
	
func damage(damage_amount: float):
	var player = get_parent() as Player
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
	set_slime_size()
	
	
func set_slime_size() -> void:
	if current_health >= XLThreshold:
		GameEvents.on_transition_to_XL.emit()
	elif current_health < XLThreshold and current_health >= largeThreshold :
		GameEvents.on_transition_to_large.emit()
	elif current_health < largeThreshold and current_health >= mediumThreshold:
		GameEvents.on_transition_to_medium.emit()
	elif current_health < mediumThreshold and current_health >= smallThreshold:
		GameEvents.on_transition_to_small.emit()
	elif current_health < smallThreshold and current_health > 0:
		GameEvents.on_transition_to_XS.emit()
	else:
		GameEvents.on_player_died.emit()
	
	
