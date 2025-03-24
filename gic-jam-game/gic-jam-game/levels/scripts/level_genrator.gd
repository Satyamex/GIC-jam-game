extends Node3D

var rng = RandomNumberGenerator.new()
@export var _modules: Array[PackedScene] = []
var offset = -131.042
var amount = 1000


func _ready():
	rng.randomize()
	for i in range(amount):
		_loop_levels(i)

func _loop_levels(index: int) -> void:
	var num = rng.randi_range(0, _modules.size() - 1)
	var loop_instance = _modules[num].instantiate()
	loop_instance.position.z = index * offset
	loop_instance.position.y = -15 * index  # Each subsequent room is lowered by 15 relative to the previous one
	add_child(loop_instance)
