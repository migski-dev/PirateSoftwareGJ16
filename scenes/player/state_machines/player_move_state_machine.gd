extends StateMachine
class_name PlayerMovementStateMachine

# Action Animations are prioritized over Movement Animations

@export var player_action_fsm: PlayerActionStateMachine 
@export var player: Player

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	
	call_deferred("set_state", states.idle)
	GameEvents.on_range_end.connect(_on_action_end)
	GameEvents.on_melee_end.connect(_on_action_end)
	GameEvents.on_special_end.connect(_on_action_end)
	
	
func _state_logic(delta):
	if player.is_dead or player_action_fsm.is_transitioning:
		return
		
	if not player.enabled_action:
		parent._apply_movement(delta)
	else:
		parent._assign_move_input()
		parent._handle_horizontal_movement(delta)
		parent._handle_vertical_movement(delta)
		parent._apply_movement(delta)
		
		var move_sign = sign(parent.velocity.x)
		if move_sign == -1:
			player.visuals.scale = Vector2(-1, 1)
		if move_sign == 1: 
			player.visuals.scale = Vector2(1,1)

		parent._get_direction()
	
	
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

# 
func _enter_state(new_state, old_state):
	# before playing a movement animation, only do so when the action state is none
	if [player_action_fsm.states.none].has(player_action_fsm.state):
		match new_state:
			states.idle:
				parent.action_anim_player.play("med_idle")
			states.run:
				parent.action_anim_player.play("med_idle")
				AudioManager.play_slime_walk_audio()
			states.jump:
				parent.action_anim_player.play("med_jump")
			states.fall:
				parent.action_anim_player.play("med_fall")
			
	
func _exit_state(old_state, new_state):
	pass


func _input(event):
	# If currently Idle or Running, then...	 
	if [states.idle, states.run].has(state) and not player_action_fsm.is_transitioning and not player_action_fsm.is_specialing:
		# Handle Jump	
		if Input.is_action_just_pressed("jump"):
			# Jumped during coyote time window
			if parent.coyote_active:
				parent.coyote_active = false
				parent._jump()
			# Queue jump buffer
			if parent.jump_buffering > 0:
				parent.jump_was_pressed = true
				parent._buffer_jump()
			# No jump buffer or coyote time window and on floor:			
			elif parent.jump_buffering == 0 and parent.coyote_time == 0 and parent.is_on_floor():
				parent._jump()
		elif Input.is_action_just_pressed("jump") and parent.is_on_floor():
			parent._jump()
			
func _on_action_end() -> void:
	if(player.velocity == Vector2.ZERO):
		call_deferred("set_state", states.idle)
