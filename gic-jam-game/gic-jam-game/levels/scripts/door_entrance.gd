extends Area3D

@export var player_health: float = randf_range(150, 220)
@export var locked: bool = false
var _door_state: String = "unlocked"

@onready var animation_player = $AnimationPlayer

func _ready():
	randomize()

func open():
	if locked:
		_door_state = "locked"
		print("Door is locked")
	else:
		_door_state = "open"
		print("Opening door")
		animation_player.play("open")
		locked = true

func close():
	if locked:
		_door_state = "closed"
		print("Closing door")
		animation_player.play("close")
		locked = false

func _on_door_state_chander_body_entered(body):
	pass
