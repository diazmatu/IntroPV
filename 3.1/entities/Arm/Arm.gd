extends Node2D

onready var fire_position = $FirePosition

export (PackedScene) var proyectile_scene:PackedScene

var container:Node

func fire():
	var new_proyectile = proyectile_scene.instance()
	container.add_child(new_proyectile)
	new_proyectile.initialize((fire_position.global_position - global_position).normalized(), fire_position.global_position)
