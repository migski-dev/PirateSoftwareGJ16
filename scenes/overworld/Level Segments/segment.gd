extends Node2D
class_name Segment

@export var ID : int
var segment_camera : Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	segment_camera = get_node("SegmentCamera")
