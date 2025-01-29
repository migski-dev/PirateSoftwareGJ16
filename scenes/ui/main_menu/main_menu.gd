extends Node2D

@onready var play_button: Button = $MenuLayer/CenterContainer/VBoxContainer/PlayButton
@onready var options_button: Button = $MenuLayer/CenterContainer/VBoxContainer/OptionsButton
@onready var controls_button: Button = $MenuLayer/CenterContainer/VBoxContainer/ControlsButton
@onready var quit_button: Button = $MenuLayer/CenterContainer/VBoxContainer/ExitButton

@onready var start_scene: PackedScene = preload("res://scenes/LevelController/level_controller.tscn")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _on_play_button_pressed() -> void:
	var start_level = start_scene.instantiate()
	get_tree().root.add_child(start_level)
	get_tree().current_scene = start_level
	get_tree().root.remove_child(self)
	queue_free()


func _on_options_button_pressed() -> void:
	$OptionsLayer.show()
	$MenuLayer.hide()


func _on_controls_button_pressed() -> void:
	$ControlsLayer.show()
	$MenuLayer.hide()


func _on_exit_button_pressed() -> void:
	get_tree().quit()



func _on_options_menu_on_back_button_pressed():
	$OptionsLayer.hide()
	$MenuLayer.show()
