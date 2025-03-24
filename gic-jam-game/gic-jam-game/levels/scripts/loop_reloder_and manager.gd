extends Node3D
var reload_scene : bool = false









func  _process(delta):
	if reload_scene == true:
		get_tree().call_deferred("reload_current_scene")
		print("ohyeah")
		reload_scene = false


func _on_door_door_opened():
	print("ohyeah")
	get_tree().call_deferred("reload_current_scene")
	print("ohyeah")
