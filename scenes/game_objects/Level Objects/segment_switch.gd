extends Area2D
class_name SegmentSwitch

signal switch_segments(from: int, to: int)
signal on_switch_enable

@export_category("Segment Pathing")
@export var from : int
@export var to : int
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player && body is not Projectile:
		print("Attempting transition: segment-" + str(from) + "| segment-" + str(to))
		emit_signal("switch_segments",from,to)

func _on_body_exited(body: Node2D) -> void:
	if body is Player and body is not Projectile:
		print_debug('printing on body exit')
		emit_signal("on_switch_enable")
