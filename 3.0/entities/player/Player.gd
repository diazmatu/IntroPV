extends KinematicBody2D

onready var cannon = $Cannon

export (float) var ACCELERATION:float = 20.0
export (float) var H_SPEED_LIMIT:float = 600.0
export (float) var FRICTION_WEIGHT:float = 0.1
export (float) var gravity:float = 1000
export (float) var jumpForce:float = -200

const FLOOR = Vector2.UP

var velocity:Vector2 = Vector2.ZERO
var projectile_container
var on_ground = false

func initialize(projectile_containerI):
	self.projectile_container = projectile_containerI
	cannon.projectile_container = projectile_container
	
func get_input():
	# Cannon rotation
	var mouse_position:Vector2 = get_global_mouse_position()
	cannon.look_at(mouse_position)
	
	# Cannon fire
	if Input.is_action_just_pressed("fire_cannon"):
		if projectile_container == null:
			projectile_container = get_parent()
			cannon.projectile_container = projectile_container
		cannon.fire()
	
	# Player movement
	var h_movement_direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
	
	
	if Input.is_action_pressed("jump") and is_on_floor():
		on_ground = false
		velocity.y += jumpForce

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	if on_ground and is_on_floor():
		on_ground = true
	velocity = move_and_slide(velocity, FLOOR)
#	if is_on_floor():
#		on_ground = true
#	else:
#		on_ground = false
#	position += velocity * delta
	

	
func notify_hit():
	_remove()

func _remove():
#	get_parent().remove_child(self)
#	queue_free()
	print("HIT")
