extends Control

var game = preload("res://levels/acene/main_loop.tscn")

func _on_play_pressed():
	get_tree().change_scene_to_file("res://levels/acene/main_loop.tscn")



func _on_quit_pressed():
	get_tree().quit()
