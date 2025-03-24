extends Area3D

@export var difficulty = 1
@export var locked: bool = true
signal door_opened

func _ready():
	locked = true  # start locked

# This method will be called to update the door state based on enemy count.
func _update_door_state(enemy_count: int) -> void:
	if enemy_count <= 0 and locked:  # Only unlock once
		locked = false
		print("All enemies defeated. Door unlocked!")

# When something enters the area, attempt to open the door.
func _on_area_entered(area):
	print("Area entered by: ", area.name)
	open()

# If a physics body enters (for example, the player)
func _on_body_entered(body):
	print("Body entered by: ", body.name)
	open()

# The open() function now checks the locked state and emits the signal only if unlocked.
func open():
	print("Attempting to open door...")
	if locked:
		print("Door is locked")
	else:
		print("Door unlocked. Emitting door_opened signal!")
		door_opened.emit()
