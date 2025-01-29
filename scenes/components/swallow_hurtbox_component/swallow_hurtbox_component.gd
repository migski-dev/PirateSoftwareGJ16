extends HurtboxComponent
class_name SwallowHurtboxComponent

@export var collision_shape: CollisionShape2D
var swallowed_projectile: bool = false

func on_area_entered(other_area: Area2D) -> void:
	if not other_area is HitboxComponent:
		return
	
	var hitbox_component = other_area as HitboxComponent
	health_component.heal(hitbox_component.damage)
	swallowed_projectile = true
	
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	floating_text.global_position = global_position + (Vector2.UP * 16)
	
	var format_string = "%0.1f"
	if round(hitbox_component.damage) == hitbox_component.damage:
		format_string = "%0.0f"
	floating_text.start(format_string % hitbox_component.damage)
	
	hit.emit()
