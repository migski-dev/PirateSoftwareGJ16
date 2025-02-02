extends StateMachine


func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", states.idle)
	
	
func _state_logic(delta):
	parent._handle_move_input()
	parent._apply_gravity(delta)
	parent._apply_movement(delta)
	
	var move_sign = sign(parent.velocity.x)
	if move_sign != 0:
		parent.visuals.scale = Vector2(move_sign, 1)
	
	
func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
		states.run: 
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump


func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("idle")
		states.run:
			print('in run state')
			#parent.anim_player.play("run")
		states.jump:
			print('in jump state')
			parent.anim_player.play("jump")
		states.fall:
			print('in fall state')
			#parent.anim_player.play("fall")
			
	
func _exit_state(old_state, new_state):
	pass


func _input(event):
	if [states.idle, states.run].has(state):
		if event.is_action_pressed("jump"):
			parent.velocity.y = parent.MAX_JUMP_VELOCITY
			parent.is_jumping = true
