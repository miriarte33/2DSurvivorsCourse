extends Node2D
class_name AxeAbility

const MAX_RADIUS = 100

@onready var hitbox: HitboxComponent = $HitboxComponent

var base_rotation = Vector2.RIGHT


func _ready():
	# Rotate starting from a random direction
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	# Tween is a way of programatically defining an animation
	var tween = create_tween()

	# Interpolates between 0 and 2 over 2 seconds
	tween.tween_method(tween_method, 0.0, 2.0, 3)

	# Callback that is called when tween is completed
	tween.tween_callback(queue_free)


# Rotates the axe in a circle around the player and gradually increases in radius
func tween_method(rotations: float):
	var percent = rotations / 3
	var current_radius = percent * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)

	var player = Utils.get_player_node(self)
	if player == null:
		return

	global_position = player.global_position + (current_direction * current_radius)
