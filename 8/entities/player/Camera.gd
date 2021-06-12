extends Camera2D

onready var animationCamera = $AnimationCamera

func _on_Player_ice_started():
	animationCamera.play("Shake")

func _on_Player_ice_stopped():
	animationCamera.stop()
