extends Node

# The max range of the sword ability
const MAX_RANGE = 150

# Export the sword ability scene to be able to spawn it at run time.
@export var sword_ability: PackedScene

var damage = 5
var base_wait_time


# Called when the node enters the scene tree for the first time.
func _ready():
	# Subscribe to the Timer timeout signal so that we can spawn
	# a sword when the timer runs out.
	var timer = get_node("Timer") as Timer
	timer.timeout.connect(on_timer_timeout)
	base_wait_time = timer.wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


# Spawns a sword to the main scene whenever the timer times out
func on_timer_timeout():
	var player = Utils.get_player_node(self)
	if player == null:
		return

	var enemies = Utils.get_distance_sorted_enemies(self, MAX_RANGE)
	if enemies.size() == 0:
		return

	var sword_instance = sword_ability.instantiate() as SwordAbility

	Utils.spawn_in_foreground_layer(self, sword_instance)
	var nearest_enemy = enemies[0] as Node2D
	sword_instance.hitbox.set_damage(damage)
	sword_instance.set_global_position(nearest_enemy.global_position)

	# TEMP: Randomize this rotation for now
	# TAU is just a constant for 2 pi.
	# This spawns the sword in a random radius of 4 around the enemy
	sword_instance.global_translate(Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4)

	# Angle the sword towards the enemy
	var enemy_direction = nearest_enemy.global_position - sword_instance.global_position
	sword_instance.rotate(enemy_direction.angle())


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id != "sword_rate":
		return

	# We reduce the spawn time by 10% for each sword rate upgrade we have
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * .1
	$Timer.wait_time = base_wait_time * (1 - percent_reduction)
	# Must start the timer again after the wait_time changes
	$Timer.start()
	print($Timer.wait_time)
