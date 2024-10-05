extends Area2D

@export_file var dialog_key = ""
@export var xoffset : int
@export var yoffset : int

var active = false

func _on_body_entered(_body):
	Signalbus.emit_signal("display_dialog", dialog_key, xoffset, yoffset)
	active = true
	
func _input(event):
	if active and event.is_action_pressed("action_1"):
		Signalbus.emit_signal("display_dialog", dialog_key, xoffset, yoffset)

func _on_body_exited(body):
	active = false
