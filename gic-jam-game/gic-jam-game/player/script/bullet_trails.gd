extends MeshInstance3D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(pos1 , pos2):
	var draw_mesh = ImmediateMesh.new()
	mesh = draw_mesh
	draw_mesh.surface_begin(Mesh.PRIMITIVE_LINES , material_override)
	draw_mesh.surface_add_vertex(pos1)
	draw_mesh.surface_add_vertex(pos2)
	draw_mesh.surface_end()
	await get_tree().create_timer(0.2).timeout
	queue_free()
