extends enemy_state
class_name EnemyAttack

@export_category("Enemy Resource")
@export var enemy: enemy

#reference to player for position
var player: CharacterBody2D
var hitbox : CollisionShape2D
var anim_player : AnimationPlayer
var attack_range :  int


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
func enter():
	
	hitbox = enemy.get_node("HurtboxComponent/CollisionShape2D")
	anim_player = enemy.get_node("Visuals/AnimationPlayer")
	attack_range = enemy.attack_range
	
	if enemy.enemy_attack_type == enemy.attack_types.MELEE:
		anim_player.play("melee_attack")
	if enemy.enemy_attack_type == enemy.attack_types.RANGED:
		anim_player.play("range_attack")

func physics_update(delta: float):
	var direction = player.global_position - enemy.global_position


	#See AnimationPlayer for how damage assignment works
	if direction.length() > attack_range:
		Transitioned.emit(self,"EnemyFollow")
	else:
		enemy.velocity = Vector2()
		enemy.velocity_component.apply_gravity(enemy, delta)
		#enemy.velocity_component.move(enemy)
