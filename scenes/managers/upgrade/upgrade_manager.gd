extends Node

# Array of the upgrades
@export var upgrade_pool: Array[AbilityUpgrade]

# Needed to connect to the level up signal
@export var experience_manager: ExperienceManager

# Used to show upgrade screen on level up
@export var upgrade_screen_scene: PackedScene

# Dictionary containing the current upgrades the player has
var current_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)


func on_level_up(_current_level: int):
	var chosen_upgrade = upgrade_pool.pick_random() as AbilityUpgrade
	if chosen_upgrade == null:
		return

	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_upgrade_choices([chosen_upgrade] as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)


func apply_upgrade(upgrade: AbilityUpgrade):
	# Add to current upgrades dictionary, or update if already there
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {"resource": upgrade, "quantity": 1}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1

	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
