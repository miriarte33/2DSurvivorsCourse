extends Node

@export var victory_screen_scene: PackedScene

# Assigns a node to a variable only when the node becomes ready
@onready var timer: Timer = $Timer


func _ready():
	timer.timeout.connect(on_timer_timeout)


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	Utils.spawn_as_child(self, victory_screen_scene.instantiate())
