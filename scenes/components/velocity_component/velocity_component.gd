extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5

var velocity = Vector2.ZERO
const GRAVITY = 900

func apply_gravity(character_body: CharacterBody2D, delta: float):
	if !character_body.is_on_floor():
		velocity.y += GRAVITY * delta
	
func accelerate_to_player():
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var direction = (player.global_position - owner_node2d.global_position).normalized()
	accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	# lazy implementation i think	
	velocity.x = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time())).x


func decelerate():
	accelerate_in_direction(Vector2.ZERO)


func move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
