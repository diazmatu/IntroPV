extends Node

onready var player = $Player
onready var turrets = $TurretsSpawner

func _ready():
	randomize()
	player.initialize(self)
	turrets.initialize(self, player)
