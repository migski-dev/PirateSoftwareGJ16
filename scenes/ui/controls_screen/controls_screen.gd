extends Control


signal on_back_pressed



func _on_options_back_button_pressed():
	on_back_pressed.emit()
