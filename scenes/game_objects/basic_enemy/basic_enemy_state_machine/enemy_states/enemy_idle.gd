extends EnemyState
class_name EnemyIdle

@export var enemy: CharacterBody2D

var move_direction : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func enter():
	pass #play idle animation from here

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
