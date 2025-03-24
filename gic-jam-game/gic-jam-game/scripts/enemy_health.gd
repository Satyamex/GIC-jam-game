extends CharacterBody3D

signal death

@export var health: float = 100
var dead: bool = false  # flag to ensure death is only processed once

func _damage(damage: float):
	if dead:
		return  # already dead, ignore further damage
	health -= damage
	if health <= 0:
		dead = true
		emit_signal("death")
		queue_free()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	move_and_slide()
