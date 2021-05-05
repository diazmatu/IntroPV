extends Node2D

onready var timer = $DeleteTimer
export (float) var deleteTime = 4
export (float) var speed:float = 800

var direction:Vector2

func initialize(container, initial_position:Vector2, fire_direction:Vector2):
	container.add_child(self)
	self.global_position = initial_position
	direction = fire_direction
	timer.wait_time = deleteTime
	timer.start()
	
func _physics_process(delta):
	position += direction * speed * delta
	
	# Si está fuera de la pantalla 
	# No lo pude aplicar
#	var visible_rect:Rect2 = get_viewport().get_visible_rect()
#	if !visible_rect.has_point(global_position):
#		_remove()

func _on_DeleteTimer_timeout():
	_remove()

func _on_KinematicBody2D_body_entered(body):
#	call_deferred("_remove")
	self._remove()
	if body.has_method("notify_hit"):
		body.notify_hit()
	if body.has_method("hit"):
		body.hit()

func _remove():
	get_parent().remove_child(self)
	queue_free()
