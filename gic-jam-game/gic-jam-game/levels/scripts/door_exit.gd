extends Area3D

@export var player_health: float = randf_range(150, 220)
@export var locked: bool = true

var _door_state: String = "true"
@onready var s_open = $open
@onready var s_close = $close
@onready var animation_player = $AnimationPlayer

func _ready():
	randomize()
	# Debug: Ensure the AnimationPlayer is found.
	if animation_player == null:
		print("AnimationPlayer node not found. Check the node path!")

func open():
	if locked:
		_door_state = "locked"
		print("Door is locked")
	else:
		print("Door is unlocked, playing open animation")
		print("opening_ejfjakj")
		$AnimationPlayer.play("open")
		_door_state = "open"
		_door_state = "locked"
		#locked = true

func close():
	if not locked:
		_door_state = "locked"
		print("Closing door")
		animation_player.play("close")

func _update_door_state(enemy_count: int) -> void:
	if enemy_count <= 0 and locked:  # Only unlock once
		locked = false
		print("All enemies defeated. Door unlocked!")
		print("locked =", locked)
		open()
