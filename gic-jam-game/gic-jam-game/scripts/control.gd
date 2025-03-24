extends Control

var game = preload("res://proto_typing_things/demo_scene/test.tscn")

func _on_play_pressed():
	get_tree().change_scene_to_file("res://proto_typing_things/demo_scene/test.tscn")



func _on_quit_pressed():
	get_tree().quit()
