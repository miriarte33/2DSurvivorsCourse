extends CharacterBody2D
class_name Player

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 25

@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities = $Abilities

var number_colliding_bodies = 0


func _ready():
	$CollisionArea.body_entered.connect(on_body_entered)
	$CollisionArea.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_bar()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = get_direction()
	var target_velocity = direction * MAX_SPEED
	velocity = Utils.smoothe_lerp(velocity, target_velocity, delta, ACCELERATION_SMOOTHING)
	move_and_slide()


# Returns a vector representing the direction the player wants to move
func get_direction():
	# get_action_stength always returns 0 or 1 with a keyboard input, it was either pressed or it wasn't
	# if move_right is not pressed, and move_left is pressed, then x movement is -1
	# if move_right is pressed, and move_left is not pressed, then x movement is 1
	# if both or neither are pressed, then x movement is 0
	var x_movement = (
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	)

	# repeat for y_movement
	# down direction in y is positive, up is negative. So move_down should go first.
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	# return the normalized input state of x and y
	return Vector2(x_movement, y_movement).normalized()


# Deals damage to the player if the damage timer is still running
# and if there are any number of colliding bodies
func maybe_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return

	health_component.damage(1)
	damage_interval_timer.start()


func update_health_bar():
	health_bar.value = health_component.get_health_percent()


func on_body_entered(_other_body: Node2D):
	number_colliding_bodies += 1
	maybe_deal_damage()


func on_body_exited(_other_body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	maybe_deal_damage()


func on_health_changed():
	update_health_bar()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if not ability_upgrade is Ability:
		return

	var ability = ability_upgrade as Ability
	abilities.add_child(ability.ability_controller_scene.instantiate())
