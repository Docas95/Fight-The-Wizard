extends Area2D

func _on_body_entered(_body):
	Signalbus.emit_signal("hurt_player")
