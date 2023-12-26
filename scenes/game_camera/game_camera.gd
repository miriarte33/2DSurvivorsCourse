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
		
	global_position = get_player_position(player)
	
	
# Gets the camera offset for the given player node
func get_player_position(player: Node2D):
	return player.global_position


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
