class_name Utils

# Method that provides Frame independent lerp between 2 points 
static func smoothe_lerp(a: Vector2, b: Vector2, time_between_frames: float, smoothing_value: int) -> Vector2:
	# "1.0 - exp(-time_between_frames * smoothing_value)" is a commonly known formula that gives you a natural
	# feeling percentage for camera smoothing to use when lerping between 2 points.
	return a.lerp(b, 1.0 - exp(-time_between_frames * smoothing_value))
	
	
# Gets the player node from the "player" group, which is the first node
# in the group.
static func get_player_node(current_node: Node) -> Node2D:
	return current_node.get_tree().get_first_node_in_group("player")
