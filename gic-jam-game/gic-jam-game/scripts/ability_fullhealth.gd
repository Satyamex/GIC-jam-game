extends Area3D

@onready var anim = $AnimationPlayer
var healed: = false
func _physics_process(delta):
	anim.play("spin-anim")
	if healed:
		print("player health now full") # for debugging you can remove it
func _on_body_entered(body):
	if body.is_in_group("player"):
		# Check if the body has a 'health' property
		if "health" in body:
			body.health = 200
			healed = true # variable for debugging u can remove it
			self.queue_free()
