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


# Function that presents the upgrades for the user to pick
func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades = upgrade_pool.duplicate()

	# Loop for however many upgrades you want to present to the user
	for i in 2:
		if filtered_upgrades.is_empty():
			break

		var chosen_upgrade = filtered_upgrades.pick_random() as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
		# Return every upgrade that does not share the ID of the chosen upgrade
		filtered_upgrades = filtered_upgrades.filter(
			func(upgrade): return upgrade.id != chosen_upgrade.id
		)

	return chosen_upgrades


func apply_upgrade(upgrade: AbilityUpgrade):
	# Add to current upgrades dictionary, or update if already there
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {"resource": upgrade, "quantity": 1}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1

	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			# Only keep the upgrades that are not the upgrade that reached
			# it's max quantity
			upgrade_pool = upgrade_pool.filter(
				func(pool_upgrade): return pool_upgrade.id != upgrade.id
			)

	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func on_level_up(_current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_upgrade_choices(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
