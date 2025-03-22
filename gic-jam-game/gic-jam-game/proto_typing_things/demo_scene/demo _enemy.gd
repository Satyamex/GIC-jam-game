extends CharacterBody3D


@export var health : float = 100

func _damage(damge:float):
	health = health - damge
	if health <= 0:
		get_parent().queue_free()
