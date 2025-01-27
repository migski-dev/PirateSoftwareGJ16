extends Node2D

@export var sprite_count: int = 5          
@export var line_length: float = 300.0      # 
@export var line_direction: Vector2 = Vector2.RIGHT 
@export var move_speed: float = 50.0       

var slime_sprite: PackedScene = preload("res://scenes/ui/main_menu/slime_sprite.tscn")

var sprite_positions: Array = []            # Array to store sprite positions
var sprites: Array = []                     # Array to store Sprite2D nodes

func _ready():
	#line_length = get_viewport_rect().size.y
	
	# Calculate the spacing between sprites
	var spacing = line_length / sprite_count
	
	# Starting point of the line
	var start_point = -line_direction * (line_length / 2)
	
	# Create sprites and position them
	for i in range(sprite_count):
		var sprite = slime_sprite.instantiate()
		add_child(sprite)
		sprites.append(sprite)
		
		# Calculate initial position
		var position = start_point + line_direction * (spacing * i)
		sprite_positions.append(position)
		sprite.position = position

func _process(delta):
	# Move sprites
	for i in range(sprite_count):
		# Update position along the line
		sprite_positions[i] += line_direction * move_speed * delta
		
		# Wrap around when the sprite goes past the end of the line
		var half_length = line_length / 2
		if sprite_positions[i].distance_to(Vector2.ZERO) > half_length:
			sprite_positions[i] -= line_direction * line_length
		
		# Apply updated position to the sprite
		sprites[i].position = sprite_positions[i]
