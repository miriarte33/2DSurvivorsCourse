extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var ability_upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = $MarginContainer/CardContainer


func _ready():
	get_tree().paused = true


func set_upgrade_choices(upgrades: Array[AbilityUpgrade]):
	for upgrade in upgrades:
		var card_instance = ability_upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)

		# Bind lets you pass in a function with an arbitrary argument while still
		# passing a reference to that function.
		# This allows us to pass a function that takes in a function with an upgrade
		# to connect to the selected signal even tho the selected signal does not take in
		# any parameters.
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))


func on_upgrade_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	get_tree().paused = false
	queue_free()
