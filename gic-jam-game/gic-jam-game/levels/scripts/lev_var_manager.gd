extends Node3D

@export var player_health:float
@export var enemy_health:float = 50
@export var  no_of_enemy_type1: int = 18
@export var  no_of_enemy_type2: int = 10
@export var _spike_spawn: bool = false
@export var enemy_type_1:bool = true
@export var enemy_type_2:bool = true


func _change_health(d_player_health:float , d_enemy_health:float):
	if d_player_health >= 70 :
		player_health = d_player_health
	else :
		player_health = 100
	if d_enemy_health >= 60:
		enemy_health = d_enemy_health
	else:
		enemy_health = 100

func _t2_enemy_activeate(level): 
	if level >= 6:
		enemy_type_2 = true
	else:
		enemy_type_2 = false
 
func _spike_manager(diff , level):
	if level >= 6:
		if diff >= 2:
			_spike_spawn = true

func _update_enemy_no(diff , level):
	pass
