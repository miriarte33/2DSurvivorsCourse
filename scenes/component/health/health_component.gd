extends Node
class_name HealthComponent

signal died

@export var max_health: float = 10
var current_health: float


func _ready():
	current_health = max_health


func damage(amount: float) -> void:
	current_health = max(current_health - amount, 0)

	# Call defered calls the provided function on the next idle frame
	Callable(emit_died).call_deferred()


func emit_died():
	if current_health == 0:
		died.emit()
		# Owner is the node that constitutes the root of the scene that this node exists in
		# Frees the scene that this HealthComponent belongs to
		owner.queue_free()
