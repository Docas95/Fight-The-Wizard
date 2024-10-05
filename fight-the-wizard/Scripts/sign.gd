extends Area2D

@export var dialog_key = ""
@export var xoffset : int
@export var yoffset : int

var area_active = false

func _input(event):
	# if the player is near the sign and presses the correct button
	# display dialog
	if area_active and event.is_action_pressed("action_1"):
		# send signal to dialog player
		Signalbus.emit_signal("display_dialog", dialog_key, xoffset, yoffset)

func _on_body_entered(_body):
	area_active = true

func _on_body_exited(_body):
	area_active = false
