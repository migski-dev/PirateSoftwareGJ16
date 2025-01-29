extends Control


@onready var start_scene: PackedScene = preload("res://scenes/LevelController/level_controller.tscn")
@onready var main_menu: PackedScene = preload("res://scenes/ui/main_menu/main_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_return_to_main_menu_pressed():
	print('asdfasdf')
	var main_menu_scene: Node2D = main_menu.instantiate()
	get_tree().root.add_child(main_menu_scene)
	get_tree().current_scene = main_menu_scene
	get_tree().root.remove_child(self)
	queue_free()


func _on_try_again_pressed():
	get_tree().reload_current_scene()
	self.visible = false
