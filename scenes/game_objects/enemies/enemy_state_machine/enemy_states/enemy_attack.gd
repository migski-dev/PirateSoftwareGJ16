extends EnemyState
class_name EnemyAttack

@export_category("Enemy Resource")
@export var enemy: CharacterBody2D

#reference to player for position
var player: CharacterBody2D
var hitbox : CollisionShape2D
var anim_player : AnimationPlayer
var attack_range :  int


func enter():
	player = get_tree().get_first_node_in_group("player")
	hitbox = enemy.get_node("HurtboxComponent/CollisionShape2D")
	anim_player = enemy.get_node("Visuals/AnimationPlayer")
	attack_range = enemy.attack_range
	anim_player.play("attack")

func physics_update(delta: float):
	var direction = player.global_position - enemy.global_position
	enemy.velocity_component.apply_gravity(enemy, delta)

	#adjust to take state machine parameter.
	if direction.length() > attack_range:
		Transitioned.emit(self,"EnemyFollow")
	else:
		enemy.velocity = Vector2()
