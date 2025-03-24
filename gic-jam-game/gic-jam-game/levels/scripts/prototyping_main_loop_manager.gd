extends Node3D

@onready var level_var_manager = $level_var_manager
@onready var enemy_t_1 = $enemy_t_1
@onready var enemy_t_2 = $enemy_t_2

var total_enemy_left: int = 0

var enemy_type_one: PackedScene = preload("res://scenes/enemy1.tscn")
var enemy_type_two: PackedScene = preload("res://proto_typing_things/demo_scene/demo_enemy_type_2.tscn")

var door = preload("res://levels/scripts/door_exit.gd")
var door_instance
var q =20
var s = -20
func _ready():
	randomize()
	door_instance = door.new()
	
	var _no_of_enimies_to_spawn_type_1 = level_var_manager.no_of_enemy_type1
	var _no_of_enimies_to_spawn_type_2 = level_var_manager.no_of_enemy_type2

	# Spawn Type 1 Enemies
	for i in range(_no_of_enimies_to_spawn_type_1):
		var enemy = enemy_type_one.instantiate()
		enemy.position.x = randf_range(s, q)
		enemy.position.z = randf_range(s, q)
		enemy_t_1.add_child(enemy)
		if enemy.has_signal("death") and not enemy.death.is_connected(_on_enemy_death):
			enemy.death.connect( _on_enemy_death)
			
	# Spawn Type 2 Enemies (if enabled)
	if level_var_manager.enemy_type_2:
		for i in range(_no_of_enimies_to_spawn_type_2):
			var enemy = enemy_type_two.instantiate()
			enemy.position.x = randf_range(s, q)
			enemy.position.z = randf_range(s, q)
			enemy_t_2.add_child(enemy)
			if enemy.has_signal("death") and not enemy.death.is_connected(_on_enemy_death):
				enemy.death.connect( _on_enemy_death)

	# Count total enemies from both containers.
	total_enemy_left = enemy_t_1.get_child_count() + enemy_t_2.get_child_count()
	print("Total enemies:", total_enemy_left)

func _on_enemy_death():
	total_enemy_left -= 1

func  _process(delta):
	door_instance.update_door_state(total_enemy_left)
 
