extends Node

@export var basic_enemy_scene: PackedScene

# This is our spawn radius because our window with is 640px
# so we want the radius to be a little bit more than half.
const SPAWN_RADIUS = 375


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(spawn_enemy)


func spawn_enemy():
	var player = Utils.get_player_node(self)
	if player == null:
		return

	# Give me a vector thats rotated in radians anywhere of 0 -> 360 degrees
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	# Spawn position is 330px in a random direction from the player
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)

	var enemy_instance = basic_enemy_scene.instantiate() as Node2D
	get_parent().add_child(enemy_instance)
	enemy_instance.set_global_position(spawn_position)
