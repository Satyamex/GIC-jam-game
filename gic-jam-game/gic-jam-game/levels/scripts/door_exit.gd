class_name Exit
extends Area3D
#
#@export var locked: bool = true
#var _door_state: String = "locked"
#
#@onready var blst_particles = $blst_particles
#@onready var animation_player = $AnimationPlayer
#
## Call this function whenever an enemy is defeated.
#func update_door_state(enemy_count: int) -> void:
	#if enemy_count <= 0 and locked:
		#locked = false
		#_door_state = "unlocked"
		#print("All enemies defeated! Exit unlocked!")
		#_play_exit_animation()
#
## Trigger the exit animation and particle effect.
#func _play_exit_animation() -> void:
	#animation_player.play("blast")
#
## Called when the animation finishes; ensure this signal is connected in _ready() or in the editor.
#func _on_animation_player_animation_finished(_anim_name: String) -> void:
	#queue_free()
#
#func _ready() -> void:
	## Connect the animation finished signal only once.
	#if not animation_player.animation_finished.is_connected(_on_animation_player_animation_finished):
		#animation_player.animation_finished.connect(_on_animation_player_animation_finished)
