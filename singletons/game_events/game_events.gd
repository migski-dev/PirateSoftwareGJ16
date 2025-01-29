extends Node

signal on_melee_end
signal on_range_start(range_cost: float)
signal on_range_end
signal on_special_end
signal on_swallow_end

signal on_player_died
signal on_transition_to_XS
signal on_transition_to_small
signal on_transition_to_medium
signal on_transition_to_large
signal on_transition_to_XL

signal on_transition_start

signal on_slime_pickup(slime_amount: int)


func emit_on_slime_pickup(slime_amount: int) -> void:
	on_slime_pickup.emit(slime_amount)
	

	

	
