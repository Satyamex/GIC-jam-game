class_name exit
extends Area3D

@export var locked: bool = true

var _door_state: String = "locked"
@onready var s_open = $open
@onready var s_close = $close
@onready var blst_particles = $blst_particles

@onready var animation_player = $AnimationPlayer



func open():
	pass
func  _exit():
	print("oheye")
	blst_particles.emitting = true
	print("dfd")
	animation_player.play("blast") 

func _update_door_state(enemy_count: int):
	if enemy_count <= 0:  # Only unlock once
		locked =false
		print("uuu")
		print(locked)
		_door_state  = "unlocked"









func _on_animation_player_animation_finished(blast):
	print("finshed")
	self.queue_free()
