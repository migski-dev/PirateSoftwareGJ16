extends EnemyState
class_name EnemyFollow

@export var enemy: CharacterBody2D
var player: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("player")
	
	var anim_player: AnimationPlayer = enemy.get_node("Visuals/AnimationPlayer") 	
	anim_player.play("walk")

func physics_update(delta: float):
	
	var direction = player.global_position - enemy.global_position
	
	enemy.velocity_component.apply_gravity(enemy, delta)

	#adjust to take state machine parameter.
	if direction.length() > 25:
		enemy.velocity_component.accelerate_in_direction(direction)
		enemy.velocity_component.move(enemy)
		#print(str(direction))
	else:
		enemy.velocity = Vector2()
		Transitioned.emit(self,"EnemyAttack")
		print("TIME TO ATTACK")
