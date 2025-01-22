extends StateMachine
class_name PlayerActionStateMachine

var is_meleeing: bool = false
var is_ranging: bool = false
var is_specialing: bool = false 


func _ready() -> void:
	add_state("none")
	add_state("melee_attack")
	add_state("range_attack")
	add_state("special_attack")
	call_deferred("set_state", states.none)
	
	GameEvents.connect("on_melee_end", _reset_action)
	GameEvents.connect("on_range_end", _reset_action)
	GameEvents.connect("on_special_end", _reset_action)


func _state_logic(delta) -> void:
	parent._handle_action_input()
	
	
func _get_transition(delta):
	print_debug(state)
	match state:
		states.none:
			if Input.is_action_pressed("melee_attack") && can_melee_attack():
				return states.melee_attack
			elif Input.is_action_pressed("range_attack") && can_range_attack():
				return states.range_attack
			elif Input.is_action_pressed("special_attack") && can_special_attack():
				return states.special_attack
			else:
				return states.none
				

func _enter_state(new_state, old_state) -> void:
	var anim_player = parent.action_anim_player as AnimationPlayer
	# TODO: Extend behavior so it matches the size state from slime component	
	match new_state:
		states.melee_attack:
			print('in melee attack')
			parent.medium_size_state._melee_attack()
			is_meleeing = true
		states.range_attack:
			parent.medium_size_state._range_attack()
			is_ranging = true
		states.special_attack:
			parent.medium_size_state._special_attack()
			is_specialing = true
		states.none:
			#anim_player.stop(false)
			is_meleeing = false
			is_ranging = false
			is_specialing = false
		
			
func can_melee_attack() -> bool:
	#TODO: Implement logic; 
	# Player can melee attack if not in melee/ special / range state 
	return true
	
	
func can_range_attack() -> bool:
	#TODO: Implement logic; 
	# Player can range attack if not in melee/special/range state AND has enough slime 
	return true


func can_special_attack() -> bool:
	#TODO: Implement logic; 
	# Player can special attack if not in melee/range/special state AND special timer = 0
	return true
	
	
func _exit_state(old_state, new_state):
	match old_state:
		states.melee_attack:
			is_meleeing = false
		states.range_attack: 
			is_ranging = false
		states.special_attack:
			is_specialing = false
	

func _reset_action() -> void:
	set_state(states.none)
