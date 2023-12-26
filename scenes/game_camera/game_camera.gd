extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# when this camera is ready, it becomes the current camera
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_player_node()
	
	if (player == null):
		return
		
	global_position = calculate_global_position(player, delta)
	

# Calculate a new global position based off the player and the delta between frames
func calculate_global_position(player: Node2D, delta: float) -> Vector2:
	# lerp is the point that is the given % away from 2 points
	# if A is at 10, and B is at 0, Point where lerp is 50% is 5.
	# We are trying to move a smooth percentage from the cameras current position to
	# the players current position
	
	# "1.0 - exp(-delta * smoothing_value)" is a formula that gives you a natural
	# feeling percentage for camera smoothing to use when lerping between 2 points.
	return global_position.lerp(player.global_position, 1.0 - exp(-delta * 10))


# Gets the player node
func get_player_node() -> Node2D:
	# "player" is a group created in the player scene that contains
	# the root player node.
	# The function get_nodes_in_group returns an array.
	# Since our player root node should be the only node in the player group,
	# we can return null if there's more than one
	var player_nodes = get_tree().get_nodes_in_group("player")
	
	if (player_nodes.size() != 1):
		return null
	
	return player_nodes[0]
