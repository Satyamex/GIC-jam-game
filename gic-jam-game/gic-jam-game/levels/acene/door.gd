extends Node3D


@export var difficulty = 1
@export var locked: bool = true
func _ready():
	locked = true

func open():
	if !locked:
		get_tree().reload_current_scene()
	if locked:
		print("door is locked")
func  _update_door_state(enmy_count):
	if enmy_count<=0:
		locked = false
		print("working")
