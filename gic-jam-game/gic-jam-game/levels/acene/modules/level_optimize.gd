extends Node3D
@onready var player_pos_check = $player_pos_check
@onready var level = $"../"

var player = preload("res://player/scene/fps_player_1_controller.tscn")
var player_pos_instance

func _ready():
	player_pos_instance = player.instantiate()

func _process(delta):
	if abs(player_pos_check.position.z - 30.0) < abs(player_pos_instance.player_current_pos):
		print("ohyeah")
		level._loop_levels(position.z + (level.amount * level.offset))
