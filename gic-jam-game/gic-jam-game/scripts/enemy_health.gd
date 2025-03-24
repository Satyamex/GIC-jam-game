extends CharacterBody3D

@export var health: float = 100
signal death

func _damage(damage: float):
	health -= damage
	if health <= 0:
		death.emit()
		queue_free()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	move_and_slide()
