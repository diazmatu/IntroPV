extends Node

export (PackedScene) var turret_scene
onready var viewport = $Control/ViewportContainer/Viewport

func initialize(player):
	var visible_rect:Rect2 = viewport.get_visible_rect()
	for i in 6:
		var turret_instance = turret_scene.instance()
		turret_instance.initialize(self, visible_rect, player)
