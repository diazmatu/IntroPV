extends KinematicBody2D

export (float) var speed:float = 200
export (float) var gravity:float = 50
export (float) var jumpForce:float = -200
const FLOOR = Vector2(0, -1)

var movement = Vector2()
var onGround = true

var jump:float = 0

#func _input(event):
#	if event.is_action_pressed("Salto"):
#		jump = -jumpForce
#	pass

func _physics_process(delta):
	
	if Input.is_action_pressed("Derecha"):
		movement.x = speed
	elif Input.is_action_pressed("Izquierda"):
		movement.x = -speed
	else:
		movement.x = 0
	
	if Input.is_action_pressed("Salto"):
		if onGround == true:
			movement.y = jumpForce
			onGround = false
	
	movement.y += gravity
	
	if is_on_floor():
		onGround = true
	else:
		onGround = false
	
	movement = move_and_slide(movement, FLOOR)
#	var right:bool = Input.is_action_pressed("Derecha")
#	var left:bool = Input.is_action_pressed("Izquierda")
#	var up:bool = Input.is_action_pressed("Salto")
#
#	var direction:int = int(Input.is_action_pressed("Derecha")) - int(Input.is_action_pressed("Izquierda"))
#	position.x += direction * speed * delta
#
#	jump += gravity * delta
#
#	position.y += jump * delta
