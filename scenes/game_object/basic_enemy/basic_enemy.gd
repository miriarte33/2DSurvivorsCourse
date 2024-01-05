extends CharacterBody2D

const MAX_SPEED = 40

@onready var health_component: HealthComponent = $HealthComponent


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Moves toward the player every frame
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()


# Gets the direction of the basic_enemy node to the player
func get_direction_to_player() -> Vector2:
	var player = Utils.get_player_node(self)

	if player == null:
		return Vector2.ZERO

	return (player.global_position - global_position).normalized()
