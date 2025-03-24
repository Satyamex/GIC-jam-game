extends Area3D

@export var locked: bool = true

var _door_state: String = "true"
@onready var s_open = $open
@onready var s_close = $close
@onready var blst_particles = $blst_particles

@onready var animation_player = $AnimationPlayer



func open():
	pass

func _process(delta):
	if Input.is_action_just_pressed("interaction"):
		blst_particles.emitting =true
		print("dfd")
		animation_player.play()
		self.queue_free()

func _update_door_state(enemy_count: int) -> void:
	if enemy_count <= 0 and locked:  # Only unlock once
		$blst_particles.emitting=true
		$"blast\\".play()
		self.queue_free()
