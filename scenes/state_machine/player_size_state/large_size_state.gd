extends PlayerSizeState

@export var bullet_scene: PackedScene
#TODO: Set the corresponding movement variables from Resource/ Singleton (max_speed, etc)

@export var range_cost: float = 3.0


# TODO: implement large hitbox and animation
func _melee_attack() -> void:
	player.med_melee_hitbox.damage = 50
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
	
# Saw attack
func _special_attack() -> void:
	player.saw_hitbox.damage = 150
	
	player.velocity.x = 2*player.max_speed if player._get_direction() == Vector2.RIGHT else -player.max_speed*2
	player.velocity.y = 0
	player.action_anim_player.play("saw")
	AudioManager.play_slime_saw_audio()
	
		
func _on_special_end() -> void:
	player.velocity = Vector2.ZERO
	player.enabled_action = true
	AudioManager.end_slime_saw_audio()
	player._disable_saw_collision()
	

func handle_special(delta: float) -> void:
	var direction: Vector2 = player._get_direction()
	var speed_multiplier: float = 1.5
	
	player._disable_action(delta)
	player._disable_gravity(delta)
	
	if player.floor_raycast.is_colliding() and player.floor_raycast.get_collider() is TileMapLayer and not player.saw_raycast.is_colliding():
		if player.is_on_floor():
			if direction == Vector2.RIGHT:
				saw_move(Vector2(speed_multiplier * player.max_speed, 0), delta)
			else:
				saw_move(Vector2(speed_multiplier * -player.max_speed, 0), delta)
		else:
			if direction == Vector2.RIGHT:
				saw_move(Vector2(speed_multiplier * player.max_speed, speed_multiplier * -player.max_speed), delta)
			else:
				saw_move(Vector2(speed_multiplier * -player.max_speed, speed_multiplier * -player.max_speed), delta)
				
#	Go up if on a wall 			
	elif player.saw_raycast.is_colliding() and player.saw_raycast.get_collider() is TileMapLayer:
		if direction == Vector2.RIGHT:
			saw_move(Vector2(speed_multiplier * player.max_speed, speed_multiplier * -player.max_speed), delta)
		else:
			saw_move(Vector2(speed_multiplier * - player.max_speed, speed_multiplier * -player.max_speed), delta)
	
#	TODO: Test this
	elif player.ceiling_raycast.is_colliding() and player.ceiling_raycast.get_collider() is TileMapLayer and not player.floor_raycast.is_colliding():
		if direction == Vector2.RIGHT:
			saw_move(Vector2(speed_multiplier * -player.max_speed, 0), delta)
		else:
			saw_move(Vector2(speed_multiplier * player.max_speed, 0), delta)
			
	# Case: No raycasts colliding
	elif not player.floor_raycast.is_colliding() and not player.saw_raycast.is_colliding() and not player.ceiling_raycast.is_colliding():
		if player.is_on_floor():
#			Still on Ledge, need to move horizontally
			if direction == Vector2.RIGHT:
				saw_move(Vector2(speed_multiplier * player.max_speed, 0), delta)
			else:
				saw_move(Vector2(speed_multiplier * -player.max_speed, 0), delta)
		else:
#			Not on ledge, need to go straight down and have 0 horizontal movement
			if direction == Vector2.RIGHT:
				saw_move(Vector2(0,  speed_multiplier * player.max_speed), delta)
			else:
				saw_move(Vector2(0,  speed_multiplier * player.max_speed), delta)

func saw_move(move_direction: Vector2, delta: float) -> void:
	player.velocity = move_direction 

	
				

			
