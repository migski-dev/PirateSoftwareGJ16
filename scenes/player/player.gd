extends CharacterBody2D
class_name Player

const SPEED = 300.0
const MAX_JUMP_VELOCITY = -400.0
const GRAVITY = 900.0
var is_jumping = false

func _ready():
	velocity = Vector2.ZERO
	
func _apply_movement(delta):
	if is_jumping && velocity.y >= 0:
			is_jumping = false
	velocity.x = 300 * Input.get_axis("move_left", "move_right")
	move_and_slide()
	
func _apply_gravity(delta):
	velocity.y += GRAVITY * delta

func _handle_move_input():
	pass
	

	
