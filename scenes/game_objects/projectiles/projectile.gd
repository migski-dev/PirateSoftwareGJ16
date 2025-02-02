extends AnimatedSprite2D
class_name Projectile

@onready var hitbox: HitboxComponent = $HitboxComponent
@export var is_player_projectile: bool = true

@export var bullet_speed: float = 1.0
@export var bullet_dmg: float = 5.0
@export var terrain_catch : Area2D
var direction: Vector2 = Vector2.ZERO

func _ready():
	hitbox.damage = bullet_dmg
	terrain_catch.connect("body_entered", _on_body_entered)
	
	if is_player_projectile:
		hitbox.set_collision_layer_value(3, false)
		hitbox.set_collision_layer_value(2, true)
		hitbox.set_collision_mask_value(3, false)
		hitbox.set_collision_mask_value(2, true)
	else:
		hitbox.set_collision_layer_value(3, true)
		hitbox.set_collision_layer_value(2, false)
		hitbox.set_collision_mask_value(3, true)
		hitbox.set_collision_mask_value(2, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if not is_player_projectile: 
	#	pass
	position += direction * bullet_speed * delta
	#if not is_on_screen():
	#	queue_free()
	
func travel(target_direction: Vector2):
	# Set up code in case we want to be able to aim (not just left and right)	
	#direction = (target_direction - global_position).normalized()
	direction = target_direction
	
func is_on_screen() -> bool: 
	var viewport = get_viewport_rect()
	return viewport.has_point(global_position)
	
func _on_body_entered(body) -> void:
	if body is TileMapLayer:
		queue_free()
