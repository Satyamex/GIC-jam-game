extends Area3D

@export var difficulty = 1
@export var locked: bool = true
signal door_opened

func _ready():
	locked = true

func open():
	print("door_unlocked")
	if !locked:
		print("Reloading Scene...")
		emit_signal("door_opened")
	else:
		print("Door is locked")

func _update_door_state(enemy_count):
	if enemy_count <= 0 and locked:  # Ensure it only runs once
		locked = false
		print("All enemies defeated. Unlocking door...")
		open()
