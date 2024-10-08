extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Zones/tutorial_zone.tscn")
	
func _on_controls_pressed():
	pass

func _on_quit_pressed():
	get_tree().quit()
