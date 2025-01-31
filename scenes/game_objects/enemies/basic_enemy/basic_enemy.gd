extends CharacterBody2D
class_name enemy

#Component Decorators
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var hitbox_component = $CollisionShape2D
enum attack_types {MELEE, RANGED, SPECIAL}

@export_category("Enemy Config")
@export var initial_state : enemy_state
@export var enemy_attack_type : attack_types = attack_types.MELEE
@export var enemy_detection_radius = 100
@export var attack_range : int = 35
@export var attack_damage : int = 5
@export var bullet_scene: PackedScene
@export var mid_point: Marker2D

var player : CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	$HitboxComponent.damage = attack_damage
	$HurtboxComponent.hit.connect(on_hit)
	apply_floor_snap()
	
func _process(delta):
	pass
		
func _physics_process(delta: float) -> void:
	#make enemy face direction methinks?
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
	pass

func on_hit():
	print_debug('I GOT HIT')
	
func on_attack():
	print_debug('I HIT SOMETHING')
	
func on_ranged_attack():
	var target_direction = (player.global_position- self.global_position).normalized()
		
	var bullet: Projectile = bullet_scene.instantiate()
	bullet.is_player_projectile = false
	bullet.global_position = mid_point.global_position
	bullet.travel(target_direction * 100)
	get_tree().root.add_child(bullet)
	print_debug('I SHOOT SOMETHING')
