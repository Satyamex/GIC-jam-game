extends Node3D


func  _input(event):
	if event.is_action_pressed("menu"):
		get_tree().quit()
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # for debugging
