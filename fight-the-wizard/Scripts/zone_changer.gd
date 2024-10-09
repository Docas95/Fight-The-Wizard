extends Area2D

@export_file var new_zone

func _on_body_entered(_body):
	get_tree().change_scene_to_file(new_zone)
