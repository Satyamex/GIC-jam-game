extends Node3D

@export var damage: = 30

var player: Node3D 
@onready var enemy_raycast: = $RayCast3D

# TIMER VARIABLES
@export var shoot_timer = 4.0
var can_shoot = true

func _ready():
	# Find the player node dynamically in the scene tree
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]  # Assign the first player in the group

func _physics_process(delta):
	if player:
		# Make the enemy look at the player's position
		look_at(player.global_transform.origin)
		# Optional: Lock rotation on the X and Z axes to keep the enemy upright
		rotation.x = 0
		rotation.z = 0

	# HANDLE SHOOTING TIMER
	if !can_shoot:
		shoot_timer -= delta
		if shoot_timer <= 0:
			# 50% CHANCE TO SHOOT AGAIN OR WAIT 2 MORE SECONDS
			if randi() % 2 == 0:
				can_shoot = true
				shoot_timer = 4.0
			else:
				shoot_timer = 2.0

	# ONLY SHOOT IF TIMER ALLOWS
	if can_shoot:
		var target = enemy_raycast.get_collider()
		if target == player and player.health > 0:
			print("player is taking damage")
			player.health -= damage
			print("player health: ", player.health)
			can_shoot = false  # RESET SHOOTING ABILITY AFTER A SHOT

	if player.health < 0:
		player.health = 0
		# REPLACE WITH DEATH CODE TO SWITCH TO DEATH MENU
