extends Area2D

@onready var text_box = $textbox

func _on_body_entered(_body):
	text_box.queue_text("A little jump never hurt anyone.")
	text_box.visible = true
	text_box.set_state_ready()

func _on_body_exited(_body):
	text_box.visible = false
	text_box.set_state_finished()
