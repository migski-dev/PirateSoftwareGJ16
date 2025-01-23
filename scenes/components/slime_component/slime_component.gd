extends HealthComponent

@export var tinyThreshold: float = 1
@export var smallThreshold: float = 3
@export var mediumThreshold: float = 5
@export var largeThreshold: float = 10
@export var XLThreshold: float = 12

signal transitionToTiny
signal transitionToSmall
signal transitionToMedium
signal transitionToLarge
signal transitionToXL
