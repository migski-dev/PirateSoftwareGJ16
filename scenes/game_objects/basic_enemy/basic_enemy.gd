extends CharacterBody2D
class_name Enemy

#Component Decorators
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var hitbox_component = $CollisionShape2D

func _ready():
	#$HitboxComponent.hit.connect(on_attack)
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
	print_debug('I attacked!')
	pass
