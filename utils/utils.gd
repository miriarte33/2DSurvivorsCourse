class_name Utils


# Method that provides Frame independent lerp between 2 points
static func smoothe_lerp(
	a: Vector2,
	b: Vector2,
	time_between_frames: float,
	smoothing_value: int,
) -> Vector2:
	# "1.0 - exp(-time_between_frames * smoothing_value)" is a commonly known formula that gives you a natural
	# feeling percentage for camera smoothing to use when lerping between 2 points.
	return a.lerp(b, 1.0 - exp(-time_between_frames * smoothing_value))


# Gets the player node from the "player" group, which is the first node
# in the group.
static func get_player_node(current_node: Node) -> Node2D:
	return current_node.get_tree().get_first_node_in_group("player")


# Returns the distance between 2 vectors.
static func distance_between(a: Vector2, b: Vector2) -> float:
	# distance_squared_to is more efficient than distance_to
	return a.distance_squared_to(b)


# Returns enemies sorted in order of distance within the provided max range
static func get_distance_sorted_enemies(node: Node, max_range: int) -> Array[Node]:
	var player = get_player_node(node)
	if player == null:
		return []

	var enemies = node.get_tree().get_nodes_in_group("enemies")
	var within_max_range = func(enemy: Node2D): 
		return Utils.distance_between(
			enemy.global_position,
			player.global_position) < pow(max_range, 2)
			
	var filteredEnemies = enemies.filter(within_max_range)
	if filteredEnemies.size() == 0:
		return []
	
	var sort_by_distance = func (a: Node2D, b: Node2D):
		var a_distance = Utils.distance_between(a.global_position, player.global_position)
		var b_distance = Utils.distance_between(b.global_position, player.global_position)
		return a_distance < b_distance

	filteredEnemies.sort_custom(sort_by_distance)
	return filteredEnemies
