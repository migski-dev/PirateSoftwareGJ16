extends Control

signal on_back_button_pressed

@onready var bgm_volume_slider: HSlider = $Panel/MarginContainer/VBoxContainer/BGMVolume
@onready var sfx_volume_slider: HSlider = $Panel/MarginContainer/VBoxContainer/SFXVolume

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(1, 60 * (log(value + 12)/log(10)) - 125)
	
func _on_bgm_volume_mute_toggled(toggled_on):
	if toggled_on:
		bgm_volume_slider.value = 0
	else:
		bgm_volume_slider.value = 100
	AudioServer.set_bus_mute(1, toggled_on)


func _on_sfx_volume_mute_toggled(toggled_on):
	if toggled_on:
		sfx_volume_slider.value = 0
	else:
		sfx_volume_slider.value = 100
	AudioServer.set_bus_mute(2, toggled_on)


func _on_sfx_volume_value_changed(value):
	AudioServer.set_bus_volume_db(2, 60 * (log(value + 12)/log(10)) - 125)


func _on_options_back_button_pressed():
	on_back_button_pressed.emit()
