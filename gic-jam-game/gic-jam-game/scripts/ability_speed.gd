extends Area3D

@onready var mesh_instance_3d = $MeshInstance3D
@onready var anim = $AnimationPlayer

var boosted := false  
var boost_duration := 5.0  

func _physics_process(delta):
	anim.play("spin-anim")
	if boosted:
		print("player velocity boosted")

func _on_body_entered(body):
	if body.is_in_group("player") and not boosted:
		boost_player(body)

func boost_player(body):
	boosted = true
	mesh_instance_3d.hide()

	# Apply speed boost
	var original_sprint_speed = body.sprinting_speed
	var original_walk_speed = body.walking_speed
	
	body.sprinting_speed *= 1.5
	body.walking_speed *= 2

	# Wait for the boost duration
	await get_tree().create_timer(boost_duration).timeout

	# Reset to original speeds
	body.sprinting_speed = original_sprint_speed
	body.walking_speed = original_walk_speed

	boosted = false
	queue_free()
