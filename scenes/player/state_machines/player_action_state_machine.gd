extends StateMachine


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
	if Input.is_action_pressed("melee_attack") && can_melee_attack():
		return states.melee_attack
	elif Input.is_action_pressed("range_attack") && can_range_attack():
		return states.range_attack
	elif Input.is_action_pressed("special_attack") && can_special_attack():
		return states.special_attack
	else:
		return states.none
	#match state:
		#states.none:
			#if Input.is_action_pressed("melee_attack") && can_melee_attack():
				#return states.melee_attack
			#elif Input.is_action_pressed("range_attack") && can_range_attack():
				#return states.range_attack
			#elif Input.is_action_pressed("special_attack") && can_special_attack():
				#return states.special_attack
			#else:
				#return states.none
				

func _enter_state(new_state, old_state) -> void:
	match new_state:
		states.melee_attack:
			print('in melee attack')
			parent.medium_size_state._melee_attack()
		states.range_attack:
			parent.medium_size_state._range_attack()
		states.special_attack:
			parent.action_anim_player.play("special_attack")
		
			
func can_melee_attack() -> bool:
	#TODO: Implement logic; can player melee attack in air?
	return true
	
	
func can_range_attack() -> bool:
	#TODO: Implement logic; can player range attack in air?
	return true


func can_special_attack() -> bool:
	#TODO: Implement logic; can player special attack in air?
	return true
	
	
func _exit_state(old_state, new_state):
	pass
	

func _reset_action() -> void:
	print_debug('enter none state')
	set_state(states.none)
