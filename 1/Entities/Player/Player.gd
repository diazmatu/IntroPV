extends Sprite

export (float) var speed:float = 20

func _process(delta):
#	var right:bool = Input.is_action_pressed("Derecha")
#	var left:bool = Input.is_action_pressed("Izquierda")
	var up:bool = Input.is_action_pressed("Salto")
	
	if up:
		while(position.y>-10):
			position.y = -speed * delta
		while(position.y<0):
			position.y = speed * delta
			
	var direction:int = int(Input.is_action_pressed("Derecha")) - int(Input.is_action_pressed("Izquierda"))
	position.x += direction * speed * delta
