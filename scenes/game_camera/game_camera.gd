extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# when this camera is ready, it becomes the current camera
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = Utils.get_player_node(self)

	if player == null:
		return

	set_global_position(calculate_global_position(player, delta))


# Calculate a new global position based off the player and the delta between frames
func calculate_global_position(player: Node2D, delta: float) -> Vector2:
	# lerp is the point that is the given % away from 2 points
	# if A is at 10, and B is at 0, Point where lerp is 50% is 5.
	return Utils.smoothe_lerp(global_position, player.global_position, delta, 20)
