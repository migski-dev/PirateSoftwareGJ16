extends EnemyState
class_name EnemyIdle

@export var enemy: Enemy

var move_direction : Vector2
var anim_player : AnimationPlayer
var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var anim_player: AnimationPlayer = enemy.get_node("Visuals/AnimationPlayer") 	
	anim_player.play("idle")
	pass # Replace with function body.

func enter():
	pass
	

func physics_update(delta: float):
	enemy.velocity_component.apply_gravity(enemy, delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
