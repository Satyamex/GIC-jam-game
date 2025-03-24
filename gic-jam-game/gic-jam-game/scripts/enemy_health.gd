extends CharacterBody3D

@export var health: float = 100
signal death

var _has_died: bool = false  # Prevents multiple death emissions

func _damage(damage: float):
	if _has_died:
		return
	health -= damage
	if health <= 0:
		_has_died = true
		emit_signal("death")
		queue_free()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	move_and_slide()
