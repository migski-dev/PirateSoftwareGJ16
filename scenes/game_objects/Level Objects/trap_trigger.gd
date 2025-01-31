extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
	$"../TileMap/TerrainTrap".collision_enabled = false
	$"../TileMap/TerrainTrap".visible = false
	pass # Replace with function body.

func _on_body_exited(body: Node2D) -> void:
	$"../TileMap/TerrainTrap".collision_enabled = true
	$"../TileMap/TerrainTrap".visible = true
	pass
	
	
