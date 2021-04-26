extends Sprite

var arm = null
onready var cadence = $Cadence
export (PackedScene) var arm_scene:PackedScene
var container:Node
var player:Sprite

export (float) var cadenceTimer = 1

func initialize(main_container, enemy):
	player = enemy
	arm = arm_scene.instance()
	self.add_child(arm)
	arm.global_position = self.position
	arm.container = main_container
	
	cadence.set_wait_time(cadenceTimer)
	cadence.start()

func _process(_delta):
	
		var player_position:Vector2 = player.position
		player_position -= arm.global_position
		arm.rotation = player_position.normalized().angle()


func _on_Cadence_timeout():
	arm.fire()
