extends Node3D


@export var difficulty = 1
@export var locked: bool = true

func open():
	if !locked:
		get_tree().reload_current_scene()
	if locked:
		print("door is locked")
