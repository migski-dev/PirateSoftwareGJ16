extends PlayerSizeState

@export var bullet_scene: PackedScene


#TODO: Set the corresponding movement variables from Resource/ Singleton (max_speed, etc)

@export var range_cost: float = 2.0

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
	if player.swallow_hitbox.swallowed_projectile: 
		bullet.bullet_dmg = projectile_damage*2
		player.swallow_hitbox.swallowed_projectile = false
	else:
		bullet.bullet_dmg = projectile_damage
	bullet.travel(target_position * 100)
	get_tree().root.add_child(bullet)
	
# Swallow Action
func _special_attack() -> void:
	player.enabled_action = false
	player.velocity = Vector2.ZERO
	player.enabled_action = false
	player.swallow_hitbox.collision_shape.disabled = false
	player.action_anim_player.play("swallow")


func handle_special(delta: float) -> void:
	if Input.is_action_just_released("special_attack"):
		GameEvents.on_special_end.emit()
		player.player_action_fsm._reset_action()
		player.enabled_action = true
		player.swallow_hitbox.collision_shape.disabled = true
		
		#GameEvents.on_swallow_end.emit()
		
		

func _on_special_end() -> void:
	pass
