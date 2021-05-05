extends Node2D

onready var fire_position = $FirePosition

export (PackedScene) var proyectile_scene:PackedScene

var container:Node
var player:KinematicBody2D

func initializeTurretArm(turret, mainContainer, playerV):
	self.player = playerV
	turret.add_child(self)
	self.global_position = turret.position
	container = mainContainer

func initializePlayerArm(playerV, mainContainer):
	playerV.add_child(self)
	self.global_position = playerV.position
	self.container = mainContainer

func turretFire():
	var new_proyectile = proyectile_scene.instance()
	new_proyectile.initialize(container, fire_position.global_position, global_position.direction_to(player.global_position))

func playerFire():
	var new_proyectile = proyectile_scene.instance()
	new_proyectile.initialize(container, fire_position.global_position, global_position.direction_to(fire_position.global_position))
