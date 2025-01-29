extends Node2D

#Leave as default unless testing
@export_category("DEBUG TOOLS")
@export var initial_segment_number : int = 1

#holds references to all the level children
var segments : Dictionary = {}
var current_segment : Segment
var transition_cooldown : bool = false
var is_able_to_transition: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Store each level child in our dictionary so we may reference them & connect our switch segment signal to each segment_switch obj
	for child in get_children():
		if child is Segment:
			segments[child.ID] = child
			for subchild in child.get_children():
				if subchild is segment_switch:
					subchild.connect("switch_segments", Callable(self,"_on_switch_segments"))
					subchild.connect("on_switch_enable", _on_switch_enable)
	
	current_segment = segments[initial_segment_number]
	current_segment.segment_camera.make_current()

func _on_switch_segments(from: int, to: int):
	if not is_able_to_transition:
		return
	is_able_to_transition = false

	if not segments[to].segment_camera.is_current():
		var to_segment: Segment = segments[to]
		to_segment.segment_camera.make_current()
	
func _on_switch_enable() -> void:
	is_able_to_transition = true
