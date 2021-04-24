extends Sprite

onready var arm = $Arm

var speed = 200 #Pixeles

#var proyectile_scene:PackedScene = load("res://entities/player/PlayerProyectile.tscn")
#export (PackedScene) var proyectile_scene:PackedScene


#func _ready():
#	arm = $Arm

func initialize(proyectile_container):
	arm.container = proyectile_container

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
	
	if Input.is_action_just_pressed("Fire"):
		arm.fire()
	
	# Manera optimizada
	var direction_optimized:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	position.x += direction_optimized * speed * delta
