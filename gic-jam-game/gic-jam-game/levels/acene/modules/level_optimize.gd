extends Node3D
@onready var player_pos_check = $player_pos_check

@onready var level = $"../"

var player = preload("res://player/scene/fps_player_1_controller.tscn")
var player_pos_instance
# Called when the node enters the scene tree for the first time.
func _ready():
	player_pos_instance = player.instantiate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if abs(player_pos_check.position.x) < abs(player_pos_instance.player_current_pos):
		level._loop_levels(position.x +(level.amount*level.offset))
