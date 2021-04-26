extends Node

onready var player = $Player
onready var turrets = [
	$Turret,
	$Turret2,
	$Turret3
]

func _ready():
	player.initialize(self)
	for t in turrets:
		t.initialize(self, player)
