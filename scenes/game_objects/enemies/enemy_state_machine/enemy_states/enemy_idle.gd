extends enemy_state
class_name EnemyIdle

@export var enemy: enemy
var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func enter():
	var anim_player: AnimationPlayer = enemy.get_node("Visuals/AnimationPlayer")
	anim_player.play("idle")

func physics_update(delta: float):
	var direction = player.global_position - enemy.global_position

	#adjust to take state machine parameter.
	if direction.length() > enemy.enemy_detection_radius:
		Transitioned.emit(self,"EnemyIdle")
		enemy.velocity_component.move(enemy)
		enemy.velocity_component.apply_gravity(enemy, delta)
	#enemy.velocity_component.move(enemy)
	else:
		Transitioned.emit(self,"EnemyFollow")
