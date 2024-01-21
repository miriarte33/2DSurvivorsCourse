extends Node

@onready var player: Player = %Player

@export var end_screen_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	player.health_component.died.connect(on_player_died)


func on_player_died():
	var end_screen = end_screen_scene.instantiate()
	Utils.spawn_as_child(self, end_screen)
	end_screen.set_defeat()
