extends Node
class_name PlayerSizeState

@export var player: Player

func _melee_attack() -> void:
	pass
	
func _range_attack(target_position: Vector2) -> void:
	pass
	
func _special_attack() -> void:
	pass

func emit_on_melee_end() -> void:
	print_debug('exit melee state')
	GameEvents.on_melee_end.emit()

	
func emit_on_range_end() -> void:
	GameEvents.on_range_end.emit()


func emit_on_special_end() -> void:
	GameEvents.on_special_end.emit()
