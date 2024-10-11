extends Area2D

const SPEED = 100
var killed = false

func _process(delta):
	if killed:
		self.position.y += delta * SPEED * 2
		return

func _on_area_entered(_area):
	killed = true
