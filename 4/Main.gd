extends Node

onready var player = $Player

func _ready():
	randomize()
	player.initialize(self)

func get_input():
	if Input.is_action_pressed("Reset"):
		player.initialize(self)
