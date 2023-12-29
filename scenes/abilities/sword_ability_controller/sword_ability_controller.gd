extends Node

# The max range of the sword ability
const MAX_RANGE = 150

# Export the sword ability scene to be able to spawn it at run time.
@export var sword_ability: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	# Subscribe to the Timer timeout signal so that we can spawn
	# a sword when the timer runs out.
	var timer = get_node("Timer") as Timer
	timer.timeout.connect(on_timer_timeout)


# Spawns a sword to the main scene whenever the timer times out
func on_timer_timeout():
	var player = Utils.get_player_node(self)
	if player == null:
		return

	var enemies = Utils.get_distance_sorted_enemies(self, MAX_RANGE)
	var sword_instance = sword_ability.instantiate() as Node2D

	# this line adds the sword instance to the main scene which is the parent of player
	player.get_parent().add_child(sword_instance)
	sword_instance.global_position = enemies[0].global_position
