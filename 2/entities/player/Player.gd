extends Sprite

var arm = null
onready var cadence = $Cadence
export (PackedScene) var arm_scene:PackedScene
var container:Node

export (float) var speed = 200 #Pixeles

export (float) var cadenceTimer = 0.25
var can_shoot = true

#var proyectile_scene:PackedScene = load("res://entities/player/PlayerProyectile.tscn")
#export (PackedScene) var proyectile_scene:PackedScene

#func _ready():
#	arm = arm_scene.instance()
#	container.add_child(arm)
#	arm_scene.global_position = self.position

#func _ready():
#	arm = $Arm

func initialize(main_container):
	arm = arm_scene.instance()
	self.add_child(arm)
	arm.global_position = self.position
	arm.container = main_container

func _physics_process(delta):
	# Manera básica
#	var direction:int = 0
#	if Input.is_action_pressed("move_left"):
#		direction = -1
#	elif Input.is_action_pressed("move_right"):
#		direction = 1
#
	#position.x += direction * speed * delta
	
#	var arm = get_node("Arm")

#	var mouse_position:Vector2 = get_local_mouse_position()
	var mouse_position:Vector2 = get_global_mouse_position()
	mouse_position -= arm.global_position
	arm.rotation = mouse_position.normalized().angle()
	
	cadence.set_wait_time(cadenceTimer)
	if Input.is_action_pressed("Fire") && can_shoot:
		arm.fire()
		can_shoot = false
		cadence.start()
	elif Input.is_action_just_pressed("Fire"):
		can_shoot = false
		arm.fire()

	# Manera optimizada
	var direction_optimized:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	position.x += direction_optimized * speed * delta

func _on_Cadence_timeout():
	can_shoot = true
