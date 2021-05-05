extends StaticBody2D

onready var cadence = $Cadence
export (PackedScene) var arm_scene:PackedScene
export (float) var cadenceTimer = 1

var player:KinematicBody2D
var container:Node
var viewpoint
var arm

func initialize(main_container, viewpointMain, playerMain):
	player = playerMain
	viewpoint = viewpointMain
	self.spawn()
	main_container.add_child(self)
	arm = arm_scene.instance()
	arm.initializeTurretArm(self, main_container, player)	

func _process(_delta):
		var player_position:Vector2 = player.position
		player_position -= arm.global_position
		arm.rotation = player_position.normalized().angle()

func spawn():
	var turret_pos:Vector2 = Vector2(rand_range(viewpoint.position.x, viewpoint.end.x), rand_range(viewpoint.position.y + 30, player.global_position.y - 50))
	global_position = turret_pos

func _on_Cadence_timeout():
	arm.turretFire()

func _on_Range_body_entered(body):
	if body.has_method("notify_hit"):
		arm.turretFire()
		cadence.set_wait_time(cadenceTimer)
		cadence.start()


func _on_Range_body_exited(body):
	if body.has_method("notify_hit"):
		cadence.stop()

func hit():
	spawn()
