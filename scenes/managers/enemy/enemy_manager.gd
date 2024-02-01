extends Node

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var timer: Timer = $Timer

var base_spawn_time = 0

# This is our spawn radius because our window with is 640px
# so we want the radius to be a little bit more than half.
const SPAWN_RADIUS = 375


# Called when the node enters the scene tree for the first time.
func _ready():
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position() -> Vector2:
	var player = Utils.get_player_node(self)
	if player == null:
		return Vector2.ZERO

	# Give me a vector thats rotated in radians anywhere of 0 -> 360 degrees
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))

	# Spawn position is 330px in a random direction from the player
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)

	# Add a ray cast (line in which you check for collisions) to prevent invalid spawn points
	# We are looking for collisions in the 1 mask
	# You have to provide the bit value of the mask
	var ray_query_parameters = PhysicsRayQueryParameters2D.create(
		player.global_position, spawn_position, 1 << 0
	)
	var ray = get_tree().root.world_2d.direct_space_state.intersect_ray(ray_query_parameters)
	if ray.is_empty():
		# No collision in the desired spawn_position
		return spawn_position
	else:
		# Theres a collision, get a new spawn_position
		return get_spawn_position()


func spawn_enemy():
	var player = Utils.get_player_node(self)
	if player == null:
		return

	var enemy_instance = basic_enemy_scene.instantiate() as Node2D

	Utils.spawn_in_entities_layer(self, enemy_instance)
	var spawn_position = get_spawn_position()
	enemy_instance.set_global_position(spawn_position)


func on_timer_timeout():
	timer.start()
	spawn_enemy()


func on_arena_difficulty_increased(arena_difficulty: int):
	# 5 seconds per difficulty increase, and there's 12 5 seconds intervals
	# in a minute.
	# We want to reduce the spawn_time by .1 every minute.
	# The min ensures that the wait_time can only be a minimum
	# of .3 since we are clamping the time off down to .7
	var time_off = min((.1 / 12) * arena_difficulty, .7)
	timer.wait_time = base_spawn_time - time_off
