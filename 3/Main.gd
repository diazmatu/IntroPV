extends Node

onready var player = $Player
onready var turrets = $TurretsSpawner
#onready var viewport = $Control/ViewportContainer/Viewport

func _ready():
	randomize()
	player.initialize(self)
	turrets.initialize(player)


func _on_Limits_body_entered(body):
	if body.has_method("respawn"):
		body.respawn()
