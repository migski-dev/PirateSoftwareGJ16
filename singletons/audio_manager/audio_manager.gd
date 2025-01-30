extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _randomize_pitch() -> float:
	return randf_range(.8, 1.2)


func play_bgm_audio() -> void:
	$bgm_audio.play()

func play_slime_walk_audio() -> void:
	$walk_audio.pitch_scale = _randomize_pitch()
	$walk_audio.play()
	
	
func play_slime_jump_audio() -> void:
	$jump_audio.pitch_scale = _randomize_pitch()
	$jump_audio.play()
	
	
func play_slime_melee_audio() -> void:
	$melee_audio.pitch_scale = _randomize_pitch()
	$melee_audio.play()
	
	
func play_slime_range_audio() -> void:
	$range_audio.pitch_scale = _randomize_pitch()
	$range_audio.play()
	
	
func play_slime_swallow_audio() -> void:
	$swallow_audio.pitch_scale = _randomize_pitch()
	$swallow_audio.play()
	
	
func play_slime_saw_audio() -> void:
	$saw_audio.pitch_scale = _randomize_pitch()
	$saw_audio.play()
	
func end_slime_saw_audio() -> void:
	$saw_audio.stop()
	
	
func play_slime__audio() -> void:
	$_audio.pitch_scale = _randomize_pitch()
	$_audio.play()
	
	
