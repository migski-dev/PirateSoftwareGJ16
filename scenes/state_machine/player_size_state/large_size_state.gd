extends PlayerSizeState
# TODO: THIS IS CURRENTLY A COPY OF MEDIUM; NEED TO DEFINE THE BEHAVIOR FOR LARGE STATE HERE
@export var bullet_scene: PackedScene
#TODO: Set the corresponding movement variables from Resource/ Singleton (max_speed, etc)

@export var range_cost: float = 25.0

func _melee_attack() -> void:
	player.med_melee_hitbox.damage = 3
	player.action_anim_player.play("med_melee_attack")
	


# Projectile Attack	
func _range_attack(target_position: Vector2) -> void:
	GameEvents.on_range_start.emit(range_cost)
	player.action_anim_player.play("med_range_attack")
	
	var bullet: Projectile = bullet_scene.instantiate()
	bullet.global_position = player.mid_point.global_position
	bullet.travel(target_position * 100)
	get_tree().root.add_child(bullet)
	
# Swallow Action
func _special_attack() -> void:
	player.action_anim_player.play("med_range_attack")
