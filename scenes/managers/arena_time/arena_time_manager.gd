extends Node
class_name ArenaTimeManager

signal arena_difficulty_increased(arena_difficulty: int)

# The amount of seconds to wait before updating our difficulty
const DIFFICULTY_INTERVAL = 5

@export var end_screen_scene: PackedScene

# Assigns a node to a variable only when the node becomes ready
@onready var timer: Timer = $Timer

var arena_difficulty = 0


func _ready():
	timer.timeout.connect(on_timer_timeout)


func _process(delta):
	# Get the target time at which to update the difficulty
	# The next time target will change any time the difficulty gets harder.
	# With an interval of 5 seconds, the first time target evaluated to 55 if the
	# timer wait time is set to 60 seconds on start.
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)

	# If the time left gets to the target, increaase the difficulty
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	Utils.spawn_as_child(self, end_screen_scene.instantiate())
