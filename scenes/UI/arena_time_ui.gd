extends CanvasLayer

@export var arena_time_manager: Node

# Because we marked Label as a unique name in the scene tree by right clicking,
# we can access it with %
@onready var label = %Label


func _process(_delta):
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)


func format_seconds_to_string(seconds: float) -> String:
	# Round down the amount of minutes
	var minutes = floor(seconds / 60)
	var remaining_seconds = seconds - (minutes * 60)
	# "%02d" is a string formatter that will format a provided number to 2 digits
	# % after gives it the parameter that we want to format
	return ("%02d" % minutes) + ":" + ("%02d" % remaining_seconds)
