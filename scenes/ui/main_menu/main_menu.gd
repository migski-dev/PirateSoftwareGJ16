extends Node2D

@onready var play_button: Button = $MenuLayer/CenterContainer/VBoxContainer/PlayButton
@onready var options_button: Button = $MenuLayer/CenterContainer/VBoxContainer/OptionsButton
@onready var controls_button: Button = $MenuLayer/CenterContainer/VBoxContainer/ControlsButton
@onready var quit_button: Button = $MenuLayer/CenterContainer/VBoxContainer/ExitButton

@onready var start_scene: PackedScene = preload("res://scenes/overworld/LevelController/level_controller.tscn")

@export var spring: float = 1500.0
@export var damp: float = 10.0
@export var multiplier: float = 50.0

var displacement: float = 0.0 
var velocity: float = 0.0

var is_play_clicked: bool = false
var is_options_clicked: bool = false
var is_controls_clicked: bool  = false

func _process(delta):
	var force = -spring * displacement - damp * velocity
	velocity += force * delta
	displacement += velocity * delta
	
	if is_play_clicked:
		$MenuLayer/CenterContainer/VBoxContainer/PlayButton.position.x = -displacement*multiplier
	
	if is_options_clicked:
		$MenuLayer/CenterContainer/VBoxContainer/OptionsButton.position.x = -displacement*multiplier
	

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _on_play_button_pressed() -> void:
	velocity = -50
	is_play_clicked = true
	await get_tree().create_timer(.5).timeout
	var start_level = start_scene.instantiate()
	get_tree().root.add_child(start_level)
	get_tree().current_scene = start_level
	get_tree().root.remove_child(self)
	queue_free()


func _on_options_button_pressed() -> void:
	velocity = -50
	is_options_clicked = true
	await get_tree().create_timer(.5).timeout
	is_options_clicked = false
	$OptionsLayer.show()
	$MenuLayer.hide()


func _on_controls_button_pressed() -> void:
	velocity = -50
	is_controls_clicked = true
	await get_tree().create_timer(.5).timeout
	is_controls_clicked = false
	$ControlsLayer.show()
	$MenuLayer.hide()


func _on_exit_button_pressed() -> void:
	get_tree().quit()



func _on_options_menu_on_back_button_pressed():
	$OptionsLayer.hide()
	$MenuLayer.show()
