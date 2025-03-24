extends Node3D

signal  reload_loop

@onready var level_var_manager = $level_var_manager
@onready var enemy_t_1 = $enemy_t_1
@onready var enemy_t_2 = $enemy_t_2

var total_enemy_left: int = 0

var enemy_type_one: PackedScene = preload("res://scenes/enemy1.tscn")
var enemy_type_two: PackedScene = preload("res://proto_typing_things/demo_scene/demo_enemy_type_2.tscn")

var door = preload("res://levels/acene/door.gd")
var door_instance

func _ready():
	door_instance = door.new()
	randomize()
	
	var _no_of_enimies_to_spawn_type_1 = level_var_manager.no_of_enemy_type1
	var _no_of_enimies_to_spawn_type_2 = level_var_manager.no_of_enemy_type2

	# Spawn Type 1 Enemies
	for i in range(_no_of_enimies_to_spawn_type_1):
		var enemy = enemy_type_one.instantiate()
		enemy.position.x = randf_range(-20, 20)
		enemy.position.z = randf_range(-20, 20)
		enemy_t_1.add_child(enemy)
		# Connect death signal only once
		if enemy.has_signal("death") and not enemy.death.is_connected(_on_enemy_death):
			enemy.death.connect(_on_enemy_death)
			
	# Spawn Type 2 Enemies (if enabled)
	if level_var_manager.enemy_type_2:
		for i in range(_no_of_enimies_to_spawn_type_2):
			var enemy = enemy_type_two.instantiate()
			enemy.position.x = randf_range(-20, 20)
			enemy.position.z = randf_range(-20, 20)
			enemy_t_2.add_child(enemy)
			if enemy.has_signal("death") and not enemy.death.is_connected(_on_enemy_death):
				enemy.death.connect(_on_enemy_death)

	# Count total enemies from the containers
	total_enemy_left = enemy_t_1.get_child_count() + enemy_t_2.get_child_count()
	print("Total enemies:", total_enemy_left)
	if door_instance.has_signal("door_opened") and not door_instance.door_opened.is_connected(_door_is_opened):
		door_instance.door_opened.connect(_door_is_opened)

func _process(delta):
	door_instance._update_door_state(total_enemy_left)

func _on_enemy_death():
	if total_enemy_left > 0:
		total_enemy_left -= 1
		print("Enemy died! Remaining:", total_enemy_left)
	else:
		print("Warning: total_enemy_left is already 0")

func _door_is_opened():
	emit_signal("reload_loop")
	print("working")
	
