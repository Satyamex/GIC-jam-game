extends CharacterBody3D

@export var health : float = 100

func _damage(damge:float):
	health -= damge
	if health <= 0:
		get_parent().queue_free()

func _physics_process(delta):
	if !is_on_floor():
		velocity.y -= 9.8 * delta
	move_and_slide()
