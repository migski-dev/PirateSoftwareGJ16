extends Control

@onready var main_menu: PackedScene = preload("res://scenes/ui/main_menu/main_menu.tscn")

func _ready():
	hide()
	
func _process(delta):
	on_input_pause()
	#if Input.is_action_pressed("pause_game"):
		#resume_game()
		
		
func _on_resume_pressed():
	_resume()
	
func _resume() -> void:
	get_tree().paused = false
	hide()
	

func _pause() -> void:
	get_tree().paused = true
	show()


func on_input_pause():
	if Input.is_action_just_pressed("pause_game") and not get_tree().paused:
		_pause()
	elif Input.is_action_just_pressed("pause_game") and get_tree().paused:
		_resume()

func _on_options_pressed():
	$OptionsMenu.show()


func _on_quit_pressed():
	get_tree().quit()


func _on_options_menu_on_back_button_pressed():
	$OptionsMenu.hide()


	
func resume_game() -> void:
	if GameEvents.is_paused:
		hide()
		Engine.time_scale = 1
		GameEvents.is_paused = false


func _on_main_menu_pressed():
	var main_menu_scene = main_menu.instantiate()
	get_tree().root.add_child(main_menu_scene)
	get_tree().current_scene = main_menu_scene
	get_tree().root.remove_child(self)
	queue_free()
