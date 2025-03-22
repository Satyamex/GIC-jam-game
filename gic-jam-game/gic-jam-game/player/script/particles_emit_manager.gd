extends Node3D
@onready var plate_particles = $decalsparticles

@onready var blood_decals = $blood_decals

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _emit_particles( on_enemy , pos , gun_pos):
	if on_enemy:
		blood_decals.position = pos
		blood_decals.look_at(gun_pos)
		blood_decals.emitting = true
	else:
		plate_particles.position = pos
		plate_particles.look_at(gun_pos)
		plate_particles.emitting = true
