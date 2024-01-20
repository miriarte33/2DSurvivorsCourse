extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health: float = 10
var current_health: float


func _ready():
	current_health = max_health


func damage(amount: float) -> void:
	current_health = max(current_health - amount, 0)
	health_changed.emit()
	# Call defered calls the provided function on the next idle frame
	# we do this so that the game doesn't start bugging after freeing the owner
	Callable(emit_died).call_deferred()


func get_health_percent():
	if max_health <= 0:
		return 0

	# Makes sure that we can't have a health greater than 1
	return min(current_health / max_health, 1)


func emit_died():
	if current_health == 0:
		died.emit()
		# Owner is the node that constitutes the root of the scene that this node exists in
		# Frees the scene that this HealthComponent belongs to
		owner.queue_free()
