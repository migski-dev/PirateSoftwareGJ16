extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent

func _ready():
	$HurtboxComponent.hit.connect(on_hit)
	apply_floor_snap()
	
func _process(delta):
	apply_floor_snap()
	velocity_component.accelerate_to_player()
	velocity_component.apply_gravity(self, delta)
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign, 1)


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()
