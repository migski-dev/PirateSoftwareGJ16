extends CharacterBody2D
class_name Player

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

@export_category("SIZE STATES")
@export var small_size_state: PlayerSizeState
@export var medium_size_state: PlayerSizeState
@export var large_size_state: PlayerSizeState


@export_category("DAMPED OSCILLATOR")
@export var spring:float = 2000.0
@export var damp:float = 8.0
@export var velocity_multiplier:float = 2.0

var displacement: float =0.0
var oscillator_velocity:float =0.0

var current_size_state: PlayerSizeState 

# Variables Dependent on Set Variables
var applied_gravity: float
var applied_terminal_velocity: float

var friction: float
var acceleration: float
var deceleration: float

var jump_magnitude: float = 500.0
var jump_count: int
var jump_was_pressed: bool = false
var coyote_active: bool = false
var gravity_active: bool = true

var enabled_action: bool = true
var is_jumping: bool = false
var is_invulnerable: bool = false

# Player Input Variables
var left_hold: bool = false
var left_tap: bool = false
var left_release: bool = false

var right_hold: bool = false
var right_tap: bool = false
var right_release: bool = false

var jump_tap: bool = false
var jump_release: bool = false

var melee_tap: bool = false
var range_tap: bool = false
var special_tap: bool = false

@onready var action_anim_player: AnimationPlayer = $ActionAnimationPlayer
@onready var hitflash_anim_player: AnimationPlayer = $HitFlashAnimationPlayer
@onready var player_action_fsm: PlayerActionStateMachine = $PlayerActionStateMachine
@onready var visuals: Node2D = $Visuals
@onready var mid_point: Marker2D = $Center
@onready var med_melee_hitbox: HitboxComponent = $Visuals/MeleeRanges/MediumMeleeHitbox
@onready var saw_hitbox: HitboxComponent = $Visuals/MeleeRanges/SawHitboxComponent
@onready var swallow_hitbox: SwallowHurtboxComponent = $Visuals/MeleeRanges/SwallowHurtboxComponent
@onready var sling_sprite: Sprite2D = $Visuals/SlimeSling
@onready var sling_hitbox_collision: CollisionShape2D = $Visuals/MeleeRanges/SlingHurtboxComponent/CollisionShape2D
@onready var player_sprite: Sprite2D = $Visuals/Sprite2D
@onready var slime_health: SlimeComponent = $SlimeComponent
@onready var saw_raycast: RayCast2D = $Visuals/MeleeRanges/SawHitboxComponent/SawRayCast2D
@onready var floor_raycast: RayCast2D = $Visuals/MeleeRanges/SawHitboxComponent/FloorRayCast2D
@onready var ceiling_raycast: RayCast2D = $Visuals/MeleeRanges/SawHitboxComponent/CielingRayCast2D

var is_dead: bool = false

func _ready() -> void:
	apply_floor_snap()
	_update_variables()
	$Visuals/MeleeRanges/MediumMeleeHitbox/CollisionShape2D.disabled = true
	
	# Is the default state medium or large?
	_on_transition_to_small()
	
	GameEvents.on_transition_to_XL.connect(_on_transition_to_large) # TODO: CREATE XL STATE
	GameEvents.on_transition_to_large.connect(_on_transition_to_large)
	GameEvents.on_transition_to_medium.connect(_on_transition_to_medium)
	GameEvents.on_transition_to_small.connect(_on_transition_to_small)
	GameEvents.on_player_death.connect(_on_player_death)

	
func _update_variables() -> void:
	# Set Acceleration / Deceleration	
	acceleration = max_speed / abs(time_to_reach_max_speed)
	deceleration = -max_speed / abs(time_to_reach_zero)
	
	# Sets jump magnitude
	jump_magnitude = (10.0 * jump_height) * gravity_scale
	print(jump_magnitude)
	
	# Sets coyote time and jump buffering	
	coyote_time = abs(coyote_time)
	jump_buffering = abs(jump_buffering)
	
func _apply_movement(delta) -> void:
	if is_jumping && velocity.y >= 0:
		is_jumping = false
	move_and_slide()
	
	# Oscillation	
	oscillator_velocity += velocity.normalized().x * velocity_multiplier
	var force = -spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity* delta
	
	player_sprite.rotation = -displacement
	
# Handles left and right player movement
func _handle_horizontal_movement(delta: float) -> void:
	# If holding both left and right input, decelerate
	if right_hold and left_hold and enabled_action:
		_decelerate(delta)
	# If holding right...	 
	elif right_hold and enabled_action:
		_handle_right_movement(delta)
	# If holding left...
	elif left_hold and enabled_action:
		_handle_left_movement(delta)
	# No movement input -> decelerate	
	if !(left_hold or right_hold):
		_decelerate(delta)


# Assigns the player input variables	
func _assign_move_input() -> void:
	left_hold = Input.is_action_pressed("move_left")
	left_tap = Input.is_action_just_pressed("move_left")
	left_release = Input.is_action_just_released("move_left")
	
	right_hold = Input.is_action_pressed("move_right")
	right_tap = Input.is_action_just_pressed("move_right")
	right_release = Input.is_action_just_released("move_right")
	
	jump_tap = Input.is_action_just_pressed("jump")
	jump_release = Input.is_action_just_released("jump")

	
func _handle_right_movement(delta: float) -> void: 
	# Caps at max speed		
	if velocity.x > max_speed:
		velocity.x = max_speed
	# Increase velocity
	else:
		velocity.x += acceleration * delta
	# Decelerate
	if velocity.x < 0:
		_decelerate(delta)


func _handle_left_movement(delta: float) -> void: 
	# Caps at - max speed 
	if velocity.x < -max_speed:
		velocity.x = -max_speed
	# Increase velocity
	else:
		velocity.x -= acceleration * delta
	# Decelerate
	if velocity.x > 0:
		_decelerate(delta)


# Slows player down
func _decelerate(delta: float) -> void:
	if (abs(velocity.x) > 0) and (abs(velocity.x) <= abs(deceleration * delta)):
		velocity.x = 0
	elif velocity.x > 0:
		velocity.x += deceleration * delta
	elif velocity.x < 0:
		velocity.x -= deceleration * delta


# Handles Jump and Gravity logic
func _handle_vertical_movement(delta) -> void:
	if player_action_fsm.is_transitioning:
		velocity = Vector2.ZERO
	# Apply gravity	
	if velocity.y > 0:
		applied_gravity = gravity_scale * descending_gravity_factor
	else: 
		applied_gravity = gravity_scale
		
	# Terminal Velocity logic	
	applied_terminal_velocity = terminal_velocity
	if gravity_active:
		if velocity.y < applied_terminal_velocity:
			velocity.y += applied_gravity
		elif velocity.y > applied_terminal_velocity:
			velocity.y = applied_terminal_velocity
			
	# Short Hop	
	if enable_var_jump_height and jump_release and velocity.y < 0:
		velocity.y = velocity.y / jump_variable
	
	# Create Coyote time window	
	if jump_count == 1 and !is_on_floor():
		if coyote_time > 0:
			coyote_active = true
			_coyote_time()
	
	# Apply coyote time / Jumps
	if is_on_floor():
		jump_count = 1
		if coyote_time > 0:
			coyote_active = true
		else:
			coyote_active = false
		if jump_was_pressed:
			_jump()


func _buffer_jump() -> void:
	await get_tree().create_timer(jump_buffering).timeout
	jump_was_pressed = false
	
	
func _coyote_time() -> void:
	await get_tree().create_timer(coyote_time).timeout
	coyote_active = false
	jump_count += -1


func _jump() -> void:
	if jump_count > 0:
		AudioManager.play_slime_jump_audio()
		velocity.y = -jump_magnitude
		jump_count += -1
		jump_was_pressed = false

func _handle_action_input():
	pass
	
func _get_direction() -> Vector2:
	if visuals.scale.x < 0:
		return Vector2.LEFT
	else:
		return Vector2.RIGHT

func _reset_velocity() -> void:
	velocity.x = 0
	velocity.y = 0

func _on_transition_to_large() -> void:
	#TODO: ADD LOGIC FOR SIZE STATE CHANGE
	await _on_transition_start()
	
	current_size_state = large_size_state
	_set_movement_stats(large_size_state)
	#visuals.scale = Vector2(2,2)
	scale = Vector2(2,2)

	#$PlayerTerrainCollision.move_local_y(-15, false)
	
func _on_transition_to_medium() -> void:
	#TODO: ADD LOGIC FOR SIZE STATE CHANGE
	await _on_transition_start()
	
	current_size_state = medium_size_state
	_set_movement_stats(medium_size_state)
	
	#visuals.scale = Vector2(1,1)
	scale = Vector2(1,1)
	
func _on_transition_to_small() -> void:
	#TODO: ADD LOGIC FOR SIZE STATE CHANGE
	await _on_transition_start()
	current_size_state = small_size_state
	_set_movement_stats(small_size_state)
	#visuals.scale = Vector2(.5, .5)
	scale = Vector2(.5,.5)

	#$PlayerTerrainCollision.move_local_y(-5, false)
	
	# To handle bug where player can heal from their own bullets after shrinking while swallowing	
	$Visuals/MeleeRanges/SwallowHurtboxComponent/CollisionShape2D.disabled = true 

func _set_movement_stats(size_state: PlayerSizeState) -> void:
	# Horizontal Movement
	max_speed = size_state.max_speed
	time_to_reach_max_speed = size_state.time_to_reach_max_speed
	time_to_reach_zero = size_state.time_to_reach_zero
	
	# Vertical Movement
	jump_height = size_state.jump_height
	gravity_scale = size_state.gravity_scale
	terminal_velocity = size_state.terminal_velocity
	descending_gravity_factor = size_state.descending_gravity_factor
	enable_var_jump_height = size_state.enable_var_jump_height
	jump_variable = size_state.jump_variable
	coyote_time = size_state.coyote_time 
	jump_buffering = size_state.jump_buffering 
	
	_update_variables()


func _on_hurtbox_component_hit() -> void:
	#TODO: play hit flash
	print("i AM HURTING")

func _disable_action(timer_amount: float) -> void:
	enabled_action = false
	await get_tree().create_timer(timer_amount).timeout
	enabled_action = true

func _invulnerable(timer_amount: float) -> void:
	is_invulnerable = true
	$Visuals/HurtboxComponent/CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(timer_amount).timeout
	$Visuals/HurtboxComponent/CollisionShape2D.set_deferred("disabled", false)
	is_invulnerable = false

func _disable_gravity(timer_amount: float) -> void:
	gravity_active = false
	await get_tree().create_timer(timer_amount).timeout
	gravity_active = true

# During size transition, make player have no movement and be invulnerable
func _on_transition_start() -> void:
	velocity = Vector2.ZERO
	_disable_action(.67)
	_disable_gravity(.67)
	await _invulnerable(.9)
	
	
func _on_player_death() -> void:
	is_dead = true
	
func shake_camera(shake_amount: float) -> void:
	GameEvents.on_shake_camera.emit(shake_amount)
	
func play_hit_flash() -> void:
	hitflash_anim_player.play("hitflash")
	
func _disable_saw_collision() -> void:
	$Visuals/MeleeRanges/SawHitboxComponent/CollisionShape2D.set_deferred("disabled", true)
