extends KinematicBody2D

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer
onready var raycast = $FirePosition/RayCast2D
onready var remove_anim_player = $RemoveAnimPlayer
onready var stateMachine = $CatStateMachine
onready var body_sprite = $Body

export (float) var FRICTION_WEIGHT:float = 0.1
export (PackedScene) var projectile_scene

var velocity = Vector2()
var direction = 1
var SPEED = 50 
var GRAVITY = 10 
var FLOOR = Vector2(0, -1)
var playerOnVision = false
var target
var projectile_container

func _ready():
	fire_timer.connect("timeout", self, "fire")
	set_physics_process(false)
	stateMachine.initialize(self)

func initialize(container, turret_pos, projectile_container):
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container

func fire():
	if target != null:
		stateMachine.set_state(stateMachine.STATES.SPIT)
		var proj_instance = projectile_scene.instance()
		if projectile_container == null:
			projectile_container = get_parent()
		proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))
		fire_timer.start()

func _play_animation(animation_name):
		body_sprite.play(animation_name)

func spit():
	body_sprite.flip_h = global_position.direction_to(target.global_position).x < 0
	raycast.set_cast_to(to_local(target.global_position))
	if raycast.is_colliding() && raycast.get_collider() == target:
		if fire_timer.is_stopped():
			fire_timer.start()
	elif !fire_timer.is_stopped():
		fire_timer.stop()

func walk():
	velocity.x = SPEED * direction     
	if direction == 1:         
		body_sprite.flip_h = false     
	else:         
		body_sprite.flip_h = true
	velocity.y += GRAVITY     
	velocity = move_and_slide(velocity, FLOOR)     
	if is_on_wall():         
		direction *= -1

func notify_hit(_amount):
	if body_sprite.animation == "dead":
		return
	stateMachine.set_state(stateMachine.STATES.DEAD)
	raycast.collision_mask = 0
	yield(body_sprite,"animation_finished")
	remove_anim_player.play("remove")

func _handle_deacceleration():
	velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
	set_process(false)
	set_physics_process(false)
	
func _remove():
	get_parent().remove_child(self)
	queue_free()


func _on_DetectionArea_body_entered(body):
	if target == null:
		target=body
		set_physics_process(true)
		playerOnVision = true
		stateMachine.set_state(stateMachine.STATES.SPIT)

func _on_DetectionArea_body_exited(body):
	if body == target:
		target = null
		set_physics_process(false)
		playerOnVision = false
		stateMachine.set_state(stateMachine.STATES.WALK)


func _on_Body_animation_finished():
	if body_sprite.animation == "spit":	
		stateMachine.set_state(stateMachine.STATES.IDLE)
