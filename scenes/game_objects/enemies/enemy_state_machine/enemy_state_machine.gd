extends Node

@onready var enemy: enemy = get_parent()
@onready var anim_player: AnimationPlayer = enemy.get_node("Visuals/AnimationPlayer")
@export var initial_state : enemy_state

var current_state : enemy_state
var current_state_name : String
var states : Dictionary = {}

var is_player_dead: bool = false

func _ready():
	for child in get_children():
		if child is enemy_state:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		
	GameEvents.on_player_death.connect(_on_player_death)

func _process(delta):
	if is_player_dead:
		return
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if is_player_dead:
		return
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name):
	
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state

func _on_player_death() -> void:
	on_child_transition(current_state, 'enemyidle')
