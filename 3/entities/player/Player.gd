extends KinematicBody2D

onready var cadence = $FireCadence

export (PackedScene) var arm_scene:PackedScene
export (float) var speed = 500 #Pixeles
export (float) var aceleration = 2000
export (float) var friction:float = 0.15
export (float) var gravity:float = 1000
export (float) var jumpForce:float = -400
export (float) var cadenceTimer = 0.25

var velocity:Vector2 = Vector2.ZERO
const FLOOR = Vector2.UP
var on_ground = false
var can_shoot = true
var container:Node
var originPosition
var arm = null

func initialize(mainContainer):
	container = mainContainer
	arm = arm_scene.instance()
	arm.initializePlayerArm(self, container)
	self.originPosition = self.position

func get_input():
	var mouse_position:Vector2 = get_global_mouse_position()
	arm.look_at(mouse_position)
	
	cadence.set_wait_time(cadenceTimer)
	if Input.is_action_pressed("Fire") && can_shoot:
		arm.playerFire()
		can_shoot = false
		cadence.start()
	elif Input.is_action_just_pressed("Fire"):
		arm.playerFire()
		can_shoot = false
		
	# Manera optimizada
	# Player movement
	var h_movement_direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * aceleration), -speed, speed)
	else:
		velocity.x = lerp(velocity.x, 0, friction) if abs(velocity.x) > 1 else 0
		
	if Input.is_action_pressed("jump") and is_on_floor():
		on_ground = false
		velocity.y += jumpForce

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	if on_ground and is_on_floor():
		on_ground = true
	velocity = move_and_slide(velocity, FLOOR)

func _on_Cadence_timeout():
	can_shoot = true
		
func notify_hit():
	respawn()

func respawn():
	self.position = self.originPosition
	print("HIT")
