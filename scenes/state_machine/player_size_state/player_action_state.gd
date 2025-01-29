extends Node
class_name PlayerSizeState

@export_category("HORIZONTAL MOVEMENT")
@export var max_speed: float = 300.0
@export var time_to_reach_max_speed: float = 0.2
@export var time_to_reach_zero: float = 0.2

@export_category("VERTICAL MOVEMENT")
# Peak Height of player jump
@export var jump_height: float = 2.0
# Strength of pull to the ground
@export var gravity_scale: float = 20.0
# Fastest the player can fall
@export var terminal_velocity: float = 500.0
# Increased player speed during falling (less floaty)
@export var descending_gravity_factor: float = 1.3
# Enable variable jump height
@export var enable_var_jump_height: bool = true
# How much jump height is cut by during short hop
@export var jump_variable: float = 2
# How much extra time does player have to jump after walking off platform
@export var coyote_time: float = 0.2
# Window of time player can have jump input registered before landing
@export var jump_buffering: float = 0.2


@export_category("Projectile")
@export var projectile_damage: float = 5

@export var player: Player

func _ready() -> void:
	GameEvents.on_special_end.connect(_on_special_end)


func _melee_attack() -> void:
	pass
	
func _range_attack(target_position: Vector2) -> void:
	pass
	
func _special_attack() -> void:
	pass
	
func _on_special_end() -> void:
	pass
	
func handle_special(delta: float) -> void:
	pass
