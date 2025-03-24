extends Node3D
var reload_scene : bool = false
@onready var loop_manager = $loop_manager  # Ensure this path is correct
var door = preload("res://levels/acene/door.gd")
var door_instance
func _ready():
	door_instance = door.new()
	if door_instance.has_signal("door_opened") and not door_instance.door_opened.is_connected(_door_is_opened):
		door_instance.door_opened.connect(_door_is_opened)




func _door_is_opened():
	print("working")
	reload_scene = true

func  _process(delta):
	if reload_scene == true:
		get_tree().call_deferred("reload_current_scene")
		print("ohyeah")
		reload_scene = false
