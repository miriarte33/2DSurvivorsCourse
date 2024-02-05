extends Node

@export var axe_ability_scene: PackedScene

@onready var timer = $Timer as Timer

var damage = 10


func _ready():
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player = Utils.get_player_node(self)
	if player == null:
		return

	var axe_instance = axe_ability_scene.instantiate() as AxeAbility
	Utils.spawn_in_foreground_layer(self, axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox.damage = damage
