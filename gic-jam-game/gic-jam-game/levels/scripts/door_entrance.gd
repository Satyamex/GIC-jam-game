extends Area3D

@export var player_health: float = randf_range(150, 220)
@export var locked: bool = false
var _door_state: String = "unlocked"


@onready var animation_player = $AnimationPlayer

func _ready():
	# Add this door to the "door" group so that it can be detected by the raycast.
	randomize()

func open():
	if locked:
		_door_state = "locked"
		print("Door is locked")
	else:
		print("Door is unlocked, playing open animation")
		_door_state = "locked"
		animation_player.play("open")
		_door_state = "open"

func close():
	if locked == false:
		_door_state = "locked"
		print("Closing door")
		animation_player.play("close")

func _on_body_entered(body):
	print(body)
	if body.is_in_group("player"):
		body.health = player_health




func _on_door_state_chander_body_entered(body):
	print(body)
	if body.is_in_group("player"):
		close()
		locked = true
		_door_state = "locked"
