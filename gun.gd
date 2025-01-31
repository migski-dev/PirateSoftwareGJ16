extends Node2D

@export var bullet_scene: PackedScene
@onready var mid_point: Marker2D = $Center
@onready var rod: Sprite2D = $ROD

var player : Player
var detected_in_radius : bool
var time : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	detected_in_radius = false
	$Area2D.body_entered.connect(player_entry)
	$Area2D.body_exited.connect(player_exit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	time += delta
	print(str(time) + "and " + str(delta))
	
	if time >= 0.5:
		if detected_in_radius:
			var target_direction = (player.global_position- self.global_position).normalized()
			var bullet: Projectile = bullet_scene.instantiate()
			$ROD.rotation = target_direction.angle()
			bullet.is_player_projectile = false
			bullet.global_position = mid_point.global_position
			bullet.travel(target_direction * 100)
			get_tree().root.add_child(bullet)
		time = time - 1
	

func player_entry(body):
	if body is Player:
		detected_in_radius = true

func player_exit(body):
	if body is Player:
		detected_in_radius = false
