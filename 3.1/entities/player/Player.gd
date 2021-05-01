extends Sprite

var arm = null
onready var cadence = $Cadence
export (PackedScene) var arm_scene:PackedScene
var container:Node

export (float) var speed = 200 #Pixeles
export (float) var aceleration = 2000
export (float) var friction = 0.15
var velocity:float = 0

export (float) var cadenceTimer = 0.25
var can_shoot = true

func initialize(main_container):
	arm = arm_scene.instance()
	self.add_child(arm)
	arm.global_position = self.position
	arm.container = main_container

func _physics_process(delta):

	var mouse_position:Vector2 = get_global_mouse_position()
#	mouse_position -= arm.global_position
#	arm.rotation = mouse_position.normalized().angle()
	arm_scene.look_at(mouse_position)
	
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
	
	if direction_optimized != 0:
		velocity = clamp(velocity + (direction_optimized * aceleration), -speed, speed)
	else:
		velocity = lerp(velocity, 0, friction) if abs(velocity) > 1 else 0
	
	position.x += velocity * delta

func _on_Cadence_timeout():
	can_shoot = true
