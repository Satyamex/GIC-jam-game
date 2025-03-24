extends Node3D

@onready var door = $"boundary/boundary 3/DOOR/door_exit"
@onready var animation_player = $"boundary/boundary 3/DOOR/door_exit/AnimationPlayer"
var locked = false  # Default value to avoid null errors

func _ready():
	if door:  # Check if the door node exists before accessing its properties
		locked = door.locked

func _on_opener_body_entered(body):
	if body.is_in_group("player"):
		if not locked:
			print("dfd")
			animation_player.play("blast") 

func _on_animation_player_animation_finished(_anim_name):
	print("finished")
	$"boundary/boundary 3/DOOR/door_exit".queue_free()  # Remove self after animation finishes
