extends PlayerSizeState


#TODO: Set the corresponding movement variables from Resource/ Singleton (max_speed, etc)


func _melee_attack() -> void:
	# TODO: Play animation, generate hurtbox, call event to transition back to none action state
	player.action_anim_player.play("med_melee_attack")


# Projectile Attack	
func _range_attack() -> void:
	player.action_anim_player.play("med_range_attack")
	
# Swallow Action
func _special_attack() -> void:
	player.action_anim_player.play("med_range_attack")
