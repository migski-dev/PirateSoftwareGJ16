extends Area2D
class_name segment_switch

signal switch_segments(from: int, to: int)
signal on_switch_enable

@export_category("Segment Pathing")
@export var from : int
@export var to : int
@onready var collision_shape: CollisionShape2D = $CollisionShape2D



func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
		

func _on_body_entered(body: Node2D) -> void:
	if body is Player && body is not Projectile:
		print("Attempting transition from segment-" + str(from) + " to segment-" + str(to))
		emit_signal("switch_segments",from,to)



func _on_body_exited(body: Node2D) -> void:
	if body is Player and body is not Projectile:
		print_debug('printing on body exit')
		emit_signal("on_switch_enable")
