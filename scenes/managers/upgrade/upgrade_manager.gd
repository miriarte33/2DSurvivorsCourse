extends Node

# Array of the upgrades
@export var upgrade_pool: Array[AbilityUpgrade]

# Needed to connect to the level up signal
@export var experience_manager: ExperienceManager

# Dictionary containing the current upgrades the player has
var current_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)


func on_level_up(_current_level: int):
	var chosen_upgrade = upgrade_pool.pick_random() as AbilityUpgrade
	if chosen_upgrade == null:
		return

	# Add to current upgrades dictionary, or update if already there
	var has_upgrade = current_upgrades.has(chosen_upgrade.id)
	if !has_upgrade:
		current_upgrades[chosen_upgrade.id] = {"resource": chosen_upgrade, "quantity": 1}
	else:
		current_upgrades[chosen_upgrade.id]["quantity"] += 1
