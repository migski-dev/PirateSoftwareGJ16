extends PlayerSizeState
# TODO: THIS IS CURRENTLY A COPY OF MEDIUM; NEED TO DEFINE THE BEHAVIOR FOR SMALL STATE HERE
@export var bullet_scene: PackedScene
#TODO: Set the corresponding movement variables from Resource/ Singleton (max_speed, etc)

@export var range_cost: float = 1.0

func _melee_attack() -> void:
	player.med_melee_hitbox.damage = 3
	player.action_anim_player.play("med_melee_attack")
	AudioManager.play_slime_melee_audio()
	
# Projectile Attack	
func _range_attack(target_position: Vector2) -> void:
	GameEvents.on_range_start.emit(range_cost)
	player.action_anim_player.play("med_range_attack")
	AudioManager.play_slime_range_audio()
	
	var bullet: Projectile = bullet_scene.instantiate()
	bullet.is_player_projectile = true
	bullet.global_position = player.mid_point.global_position
	bullet.travel(target_position * 100)
	get_tree().root.add_child(bullet)
	
# sling shot Action
func _special_attack() -> void:
	player.velocity = Vector2.ZERO
	player.enabled_action = false
	player.action_anim_player.play("slingshot")

func handle_special(delta: float) -> void:
	if player.player_action_fsm.is_winding:
		player._disable_action(delta)
		player._disable_gravity(delta)
		
#		Code to fix where slingshot base is facing
		#if (player.sling_sprite.rotation_degrees < 270 and player.sling_sprite.rotation_degrees > 90):
			#player.visuals.scale = Vector2(-1, 1)
		#else:
			#player.visuals.scale = Vector2(1, 1)
	elif player.player_action_fsm.is_flying:
		player._disable_action(delta)
		_apply_flying_gravity(delta)
		#player._disable_gravity(delta)
		

func _apply_flying_gravity(delta):
	player.velocity.y += 5

func _input(event):
	if player.current_size_state == player.small_size_state and player.player_action_fsm.is_winding:
		# Handle Jump	
		if Input.is_action_just_pressed("range_attack"):
			player.velocity = _get_launch_vector() * player.max_speed * 1.3
			player.action_anim_player.play("flying")
			player.sling_sprite.hide()
			winding_to_flying()
			print('FLY')


func _get_launch_vector() -> Vector2:
	return (player.get_global_mouse_position() - player.global_position).normalized()
			

func winding_to_flying():
	player.player_action_fsm.is_winding = false
	player.player_action_fsm.is_flying = true

		
