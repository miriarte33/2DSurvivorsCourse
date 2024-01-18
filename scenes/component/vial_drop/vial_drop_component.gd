extends Node
class_name VialDrop

# Configurable percentage of how often the vial should drop
@export_range(0, 1) var drop_percent: float = .5
# Configurable health component to be able to connect to died signal
@export var health_component: HealthComponent
# Configurable vial scene to know which vial to drop
@export var vial_scene: PackedScene


func _ready():
	health_component.died.connect(on_died)


func on_died():
	# Return early if we get a random number that is not within our drop percentage
	if randf() > drop_percent:
		return

	if vial_scene == null:
		return

	if not owner is Node2D:
		return

	var vial_instance = vial_scene.instantiate() as Node2D
	Utils.spawn_in_entities_layer(self, vial_instance)
	vial_instance.set_global_position(owner.global_position)
