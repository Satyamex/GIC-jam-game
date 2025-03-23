extends Node3D

@export var health: float = 100.0
var player: Node3D  # Store the player node reference

func _ready():
	# Find the player node dynamically in the scene tree
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]  # Assign the first player in the group
	else:
		print("Player not found!")  # Debug message if player is not found

func _process(delta):
	if player:
		# Make the enemy look at the player's position
		look_at(player.global_transform.origin)
		# Optional: Lock rotation on the X and Z axes to keep the enemy upright
		rotation.x = 0
		rotation.z = 0

func _damage(damage: float):
	health -= damage
	if health <= 0:
		print("Enemy died!")
		get_parent().queue_free()  # Remove the enemy from the scene
