extends StateMachine
class_name PlayerActionStateMachine

# TODO: In the animation player set the enabled_movement variable on the player to false at 
# the start of the swallow animation; on release of swallow > set enabled_movement to true

var is_meleeing: bool = false
var is_ranging: bool = false
var is_specialing: bool = false 
var is_transitioning:bool = false
var is_sawing: bool = false
var is_swallowing: bool = false
var is_winding:bool = false
var is_flying: bool = false

var bullet_target: Vector2 = Vector2.ZERO
var bullet_cooldown: float = 0.8
var is_on_bullet_cooldown: bool = false

@export var player_bullet: PackedScene 
@export var player: Player

func _ready() -> void:
	#GameEvents.on_swallow_end.connect(_reset_action)
	add_state("none")
	add_state("melee_attack")
	add_state("range_attack")
	add_state("special_attack")
	add_state("shrinking")
	add_state("growing")
	call_deferred("set_state", states.none)


func _state_logic(delta) -> void:
	if player.is_dead:
		return
	parent._handle_action_input()
	_handle_special_states(delta)
	
	
func _get_transition(delta):
	match state:
		states.none:
			if Input.is_action_pressed("melee_attack") && can_melee_attack():
				return states.melee_attack
			elif Input.is_action_pressed("range_attack") && can_range_attack():
				bullet_target = parent._get_direction()
				return states.range_attack
			elif Input.is_action_pressed("special_attack") && can_special_attack():
				return states.special_attack
			elif Input.is_action_pressed("shrink") && can_shrink():
				return states.shrinking
			elif Input.is_action_pressed("grow") && can_grow():
				return states.growing
			else:
				return states.none


func _enter_state(new_state, old_state) -> void:
	var anim_player = parent.action_anim_player as AnimationPlayer
	match new_state:
		states.melee_attack:
			match player.current_size_state:
				player.large_size_state:
					player.large_size_state._melee_attack()
				player.medium_size_state:
					player.medium_size_state._melee_attack()
				player.small_size_state:
					player.small_size_state._melee_attack()
			is_meleeing = true
			
		states.range_attack:
			match player.current_size_state:
				player.large_size_state:
					player.large_size_state._range_attack(bullet_target)
				player.medium_size_state:
					player.medium_size_state._range_attack(bullet_target)
				player.small_size_state:
					player.small_size_state._range_attack(bullet_target)
					
			is_ranging = true
			is_on_bullet_cooldown = true
			await get_tree().create_timer(bullet_cooldown).timeout
			is_on_bullet_cooldown = false
			
		states.special_attack:
			match player.current_size_state:
				player.large_size_state:
					player.large_size_state._special_attack()
					is_sawing = true
				player.medium_size_state:
					player.medium_size_state._special_attack()
					is_swallowing = true
				player.small_size_state:
					player.small_size_state._special_attack()
					is_winding = true
			is_specialing = true
		
		states.shrinking:
			match player.current_size_state:
				player.large_size_state:
					is_transitioning = true
					GameEvents.on_transition_to_medium.emit()
					GameEvents.on_transition_start.emit()
					player.action_anim_player.play("shrinking")
				player.medium_size_state:
					is_transitioning = true
					GameEvents.on_transition_to_small.emit()
					GameEvents.on_transition_start.emit()
					player.action_anim_player.play("shrinking")
				player.small_size_state:
					#TODO: CREATE ERROR SOUND / CAMERA SHAKE
					_reset_action()
		
		states.growing:
			match player.current_size_state:
				player.large_size_state:
					#TODO: CREATE ERROR SOUND / CAMERA SHAKE
					_reset_action()
				player.medium_size_state:
					is_transitioning = true
					GameEvents.on_transition_to_large.emit()
					GameEvents.on_transition_start.emit()
					player.action_anim_player.play("growing")
				player.small_size_state:
					is_transitioning = true
					GameEvents.on_transition_to_medium.emit()
					GameEvents.on_transition_start.emit()
					player.action_anim_player.play("growing")
		

		states.none:
			is_meleeing = false
			is_ranging = false
			is_specialing = false
			is_transitioning = false
			is_winding = false
			is_flying = false
		
			
func can_melee_attack() -> bool:
	#TODO: Implement logic; 
	# Player can melee attack if not in melee/ special / range state 
	return true
	
	
func can_range_attack() -> bool:
	#TODO: Implement logic; 
	# Player can range attack if not in melee/special/range state AND has enough 
	# slime AND not on range CD
	if is_specialing:
		return false
	if state == states.none and has_enough_slime() and not is_on_bullet_cooldown: 
		return true 
	else: 
		return false



func can_shrink() -> bool:
	match player.current_size_state:
		player.small_size_state:
			return false
		player.medium_size_state:
			return true
		player.large_size_state:
			return true
		_:
			return false


#TODO ADD GROW CHECK
func can_grow() -> bool:
	var current_health = player.slime_health.current_health
	var large_threshold = player.slime_health.largeThreshold
	var medium_threshold = player.slime_health.mediumThreshold
	
	match player.current_size_state:
		player.small_size_state:
			return current_health >= medium_threshold
		player.medium_size_state:
			return current_health >= large_threshold
		player.large_size_state:
			return false
		_:
			return false
		
		
func has_enough_slime() -> bool:
	# TODO: tie in function with slime component
	return true


func can_special_attack() -> bool:
	#TODO: Implement logic; 
	# Player can special attack if not in melee/range/special state AND special timer = 0
	if player.current_size_state == player.small_size_state and not player.is_on_floor():
		return false
	return true
	
	
func _exit_state(old_state, new_state):
	match old_state:
		states.melee_attack:
			is_meleeing = false
		states.range_attack: 
			is_ranging = false
		states.special_attack:
			is_specialing = false
			is_sawing = false
			is_swallowing = false
			is_winding = false
			is_flying = false
	

func _reset_action() -> void:
	set_state(states.none)


func emit_on_melee_end() -> void:
	GameEvents.on_melee_end.emit()
	_reset_action()

	
func emit_on_range_end() -> void:
	GameEvents.on_range_end.emit()
	_reset_action()

func emit_on_special_end() -> void:
	GameEvents.on_special_end.emit()
	_reset_action()
	


func _on_slime_component_on_damage_shrink():
	set_state(states.shrinking)
	

func _handle_special_states(delta:float) -> void:
	if(not is_specialing):
		return
		
	match player.current_size_state:
		player.large_size_state:
			player.large_size_state.handle_special(delta)
		player.medium_size_state:
			player.medium_size_state.handle_special(delta)
		player.small_size_state:
			player.small_size_state.handle_special(delta)

func _disable_sling_collision():
	player.sling_hitbox_collision.disabled = true
	
func _on_sling_hurtbox_component_body_entered(body):
	if not player.current_size_state == player.small_size_state:
		return
	if not state == states.special_attack:
		return 
	is_flying = false
	call_deferred("_disable_sling_collision")
	player._enable_layer_collision()
	#player.player_sprite.offset = Vector2.ZERO
	#await get_tree().create_timer(.1).timeout
	
	player.enabled_action = true
	player._disable_sling_hitbox()
	
	emit_on_special_end()
	#if not body is CharacterBody2D:
		#player.enabled_action = true
		#emit_on_special_end()

	# TODO: Add splat on impact?
	
