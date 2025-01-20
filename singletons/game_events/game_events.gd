extends Node

signal slime_collected(number: float)
signal player_damaged


func emit_slime_collected(number: float):
	slime_collected.emit(number)


func emit_player_damaged():
	player_damaged.emit()
