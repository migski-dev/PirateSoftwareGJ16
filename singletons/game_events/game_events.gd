extends Node

signal on_player_died

signal on_melee_end
signal on_range_end
signal on_special_end

signal on_transition_to_XS
signal on_transition_to_small
signal on_transition_to_medium
signal on_transition_to_large
signal on_transition_to_XL

func emit_on_player_died() -> void:
	on_player_died.emit()
	
