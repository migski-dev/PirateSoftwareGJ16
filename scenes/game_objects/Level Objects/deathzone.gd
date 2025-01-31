extends Area2D

var attack_damage = 9999
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HitboxComponent.damage = attack_damage
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
