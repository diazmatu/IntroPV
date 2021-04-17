extends Sprite

export (float) var speed:float = 20
export (float) var gravity:float = 50
export (float) var jumpForce:float = -100

func _process(delta):
#	var right:bool = Input.is_action_pressed("Derecha")
#	var left:bool = Input.is_action_pressed("Izquierda")
	var up:bool = Input.is_action_pressed("Salto")
	
	if up:
		var buttomJump:float = position.y 
		var jump:float = position.y 
		var topJump:float = jump + jumpForce
		while jump > topJump:
			position.y -= delta * gravity
			jump = position.y
		while jump < buttomJump :
			position.y += delta * gravity
			jump = position.y
			
	var direction:int = int(Input.is_action_pressed("Derecha")) - int(Input.is_action_pressed("Izquierda"))
	position.x += direction * speed * delta
