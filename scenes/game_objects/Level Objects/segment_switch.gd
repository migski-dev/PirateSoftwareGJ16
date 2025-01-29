extends Area2D
class_name segment_switch

@export_category("Segment Pathing")
@export var from : int
@export var to : int

signal switch_segments(from: int, to: int)

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
		

func _on_body_entered(body: Node2D) -> void:
	if body is Player && body is not Projectile:
		print("Attempting transition from segment-" + str(from) + " to segment-" + str(to))
		emit_signal("switch_segments",from,to)
	pass # Replace with function body.
