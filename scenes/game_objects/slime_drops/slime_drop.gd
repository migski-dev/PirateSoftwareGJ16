extends Node2D
class_name SlimeDrop

@onready var sprite: Sprite2D = $Sprite2D
@export var slime_restore: float = 10.0

func _ready() -> void: 
	$Area2D.area_entered.connect(on_area_entered)
	
	
func on_area_entered(other_area: Area2D) -> void:
	GameEvents.emit_on_slime_pickup(slime_restore)
	queue_free()
