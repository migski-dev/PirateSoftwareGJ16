# todo
# 1. Have animation attack call the start and finish of the attack
#		a. Hitbox may be able to be toggled from there but still call start end.
# 2. Use hitbox component script to have enemy send damage value to player

extends EnemyState
class_name EnemyAttack

@export_category("Enemy Resource")
@export var enemy: CharacterBody2D

@export_category("ATTACK TYPE")
enum attack_types {MELEE, RANGED}

@export_category("Enemy Attack")
@export var enemy_attack_type : attack_types = attack_types.MELEE
@export var attack_damage : int = 5
@export var attack_range : int = 35

#reference to player for position
var player: CharacterBody2D
var hitbox : CollisionShape2D
var anim_player : AnimationPlayer

signal attack

func Enter():
	player = get_tree().get_first_node_in_group("player")
	hitbox = enemy.get_node("HurtboxComponent/CollisionShape2D")
	anim_player = enemy.get_node("Visuals/AnimationPlayer")
	
	anim_player.play("attack")

func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	enemy.velocity_component.apply_gravity(enemy, delta)

	#adjust to take state machine parameter.
	if direction.length() > attack_range:
		Transitioned.emit(self,"EnemyFollow")
	else:
		enemy.velocity = Vector2()

func attack_end():
	match enemy_attack_type:
			attack_types.MELEE:
				hitbox.disabled = true
				pass
			attack_types.RANGED:
				pass
