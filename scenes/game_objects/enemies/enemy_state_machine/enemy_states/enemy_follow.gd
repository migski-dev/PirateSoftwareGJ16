extends enemy_state
class_name EnemyFollow

@export var enemy: enemy
var player: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func enter():
	var anim_player: AnimationPlayer = enemy.get_node("Visuals/AnimationPlayer") 	
	anim_player.play("walk")

func physics_update(delta: float):
	
	var direction = player.global_position - enemy.global_position
	
	enemy.velocity_component.apply_gravity(enemy, delta)

	#adjust to take state machine parameter.
	if direction.length() > enemy.attack_range:
		enemy.velocity_component.accelerate_in_direction(direction)
		enemy.velocity_component.move(enemy)
		enemy.velocity_component.apply_gravity(enemy, delta)
	else:
		enemy.velocity = Vector2()
		Transitioned.emit(self,"EnemyAttack")
