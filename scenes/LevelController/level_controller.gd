extends Node2D

#Leave as default unless testing
@export_category("DEBUG TOOLS")
@export var initial_segment_number : int = 1

#holds references to all the level children
var segments : Dictionary = {}
var current_segment : Segment
var transition_cooldown : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Store each level child in our dictionary so we may reference them & connect our switch segment signal to each segment_switch obj
	for child in get_children():
		if child is Segment:
			segments[child.ID] = child
			for subchild in child.get_children():
				if subchild is segment_switch:
					subchild.connect("switch_segments", Callable(self,"_on_switch_segments"))
	
	current_segment = segments[initial_segment_number]
	current_segment.segment_camera.make_current()

func _on_switch_segments(from: int, to: int):
	if transition_cooldown == false:
		if !segments[to].segment_camera.is_current():
			var to_segment : Segment = segments[to]
			to_segment.segment_camera.make_current()
			segment_switch_cooldown()
		else:
			
			return
	
func segment_switch_cooldown():
	transition_cooldown = true
	
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 1.5
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	transition_cooldown = false
