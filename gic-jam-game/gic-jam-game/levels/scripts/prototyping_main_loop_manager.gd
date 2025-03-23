extends Node3D
@onready var level_var_manager = $level_var_manager
@onready var enemy_t_1 = $enemy_t_1
@onready var enemy_t_2 = $enemy_t_2

var level: int = 1
var  _enemy_left_type1:int
var  _enemy_left_type2:int
var _no_of_enimies_to_spawn_type_1:int = 9
var _no_of_enimies_to_spawn_type_2:int = 0
var enemy_type_one :PackedScene = preload("res://assests/demo_enemy.tscn")
var enemy_type_two:PackedScene = preload("res://proto_typing_things/demo_scene/demo_enemy_type_2.tscn")
var E1
var E2

func _ready(): 
	randomize()
	E1 = enemy_type_one.instantiate()
	E2 = enemy_type_two.instantiate()
	_no_of_enimies_to_spawn_type_1 = level_var_manager.no_of_enemy_type1
	_no_of_enimies_to_spawn_type_2 =level_var_manager.no_of_enemy_type2
	#ENEMY_TYPE!SPAWM
	for i in _no_of_enimies_to_spawn_type_1:
		E1 = enemy_type_one.instantiate()
		E1.position.x = randf_range(40,-40)
		E1.position.z = randf_range(40,-40)
		enemy_t_1.add_child(E1)
	if level_var_manager.enemy_type_2 == true:
		for i in _no_of_enimies_to_spawn_type_1:
			E2 = enemy_type_two.instantiate()
			E2.position.x = randf_range(20,-20)
			E2.position.z = randf_range(20,-20)
			enemy_t_2.add_child(E2)   
