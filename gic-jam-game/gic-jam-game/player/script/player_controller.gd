# PLAYER_MOVEMENT.gd
# -------------------------------------------------------------------------------
# This script controls 3D player movement for a first-person game. It manages:
# - Movement states (walking, sprinting, crouching, jumping, idle, sliding)
# - Visual effects (camera FOV changes, head bobbing, rolling)
# - Animation triggers based on movement and state transitions
# - Shooting & reloading using RayCast3D for a shotgun
# -------------------------------------------------------------------------------

class_name PLAYER_MOVEMENT
extends CharacterBody3D

var can_play: bool

# Flags to trigger sounds only once
var crouchSoundPlayed: bool = false
var slideSoundPlayed: bool = false
var player_current_pos:float 

# ==============================================================================
#                          GLOBAL CONFIGURATION
# ==============================================================================

# ------ GRAVITY ------
@export var gravity: float = 9.8

# --- Visual Effects Settings ---
@export_group("gamejuice_things")
@export var sprint_fov: float = 15                   # Additional FOV when sprinting
@export var camera_fov_default: float = 75.0         # Default camera FOV
@export var animation_player_speed: float = 1.0      # Speed of animations

# --- Movement Speeds & Parameters ---
@export_group("MOVEMENT_VARIABLE")
var SPEED: float = 0.0                              # Active movement speed
@export var walking_speed: float = 7.0              # Walking speed
@export var crouch_walking_speed: float = 5.0       # Crouching speed
@export var sprinting_speed: float = 10.5           # Sprinting speed
@export var JUMP_VELOCITY: float = 5.5              # Jump impulse strength

# --- Mouse & Camera Settings ---
@export var sensitivity: float = 0.01               # Mouse look sensitivity
@export var captured: bool = true                   # Whether mouse is captured

# --- Crouching Settings ---
@export var crouching_depth: float = -0.6           # Head lowering value during crouch

# ------ SLIDE VARIABLES ------
var slide_timer: float = 0.0
@export var slide_timer_max: float = 1.0
var slide_dir: Vector2 = Vector2.ZERO
@export var sliding_speed: float = 13.0
@export var slide_tilt: float = -8.0

# --- Head Bobbing & Animation ---
@export_group("Animation_Things")
@export var lerp_speed: float = 15.0                # Lerp factor for smooth transitions
const head_bobing_sprinting_speed: float = 22.0      # Bobbing speed multiplier (sprinting)
const head_bobing_walking_speed: float = 14.0        # Bobbing speed multiplier (walking)
const head_bobing_crouching_speed: float = 8.0       # Bobbing speed multiplier (crouching)

const head_bobing_sprinting_intensity: float = 0.4   # Bobbing intensity (sprinting)
const head_bobing_walking_intensity: float = 0.2     # Bobbing intensity (walking)
const head_bobing_crouching_intensity: float = 0.1   # Bobbing intensity (crouching)

# --- Node References ---
@onready var un_crouched_collision_shape = $un_crouched_collision_shape
@onready var crouched_collision_shape = $crouched_collision_shape
@onready var obstacle_checker = $head/obstacle_check/obstacle_checker
@onready var camera = $head/eye/Camera3D
@onready var head = $head
@onready var eye = $head/eye
@onready var player_animation = $PLAYER_ANIMATION
@onready var sub_viewport = %SubViewport
@onready var pov_2 = $head/eye/SubViewportContainer/SubViewport/POV_2
@onready var shothun = $head/eye/shothun
@onready var bullets_container = $head/eye/shothun/bullets_container
@onready var bullets_labels = %bullets_labels
@onready var jump = $audio/jump
@onready var footsteps = $audio/footsteps
@onready var barrel_pos = $head/eye/SubViewportContainer/SubViewport/POV_2/fps_pov/shotgun/model_shotgun/RootNode/weapon_scifi_shotgun/barrelpos
@onready var crosshair = $head/eye/Camera3D/UI/player_movement_Debugger/TextureRect
@onready var bullet_icon = $head/eye/Camera3D/UI/player_movement_Debugger/TextureRect2
@onready var health_label = %health_label
@onready var interaction_ray_cast = $head/eye/door_checker/interaction_ray_cast
@onready var interaction_test = $"head/eye/Camera3D/UI/player_movement_Debugger/interaction test"

@onready var ray_end_pos = $head/eye/shothun/ray_end_pos

@onready var timer = $Timer # timer to fix gun shot spam glitch

# --- Debug Displays ---
var PLAYER_SPEED: int = self.velocity.length()   # Current speed for debugging
@onready var speed_label = %speed_label
@onready var state = %state
# ============================ SHOTGUN MANAGER ============================
var spread: float = 7.0                        # Spread value for randomizing ray directions
var damage: float = 30.0                         # Damage per pellet hit
var bullets_per_reload: int = 5                   # Number of bullets per reload
var max_bullets_per_reload_capacity: float = 5.0  # Current magazine capacity
var mag_size: float = 15.0                        # Total magazine size (if using total ammo)
var max_mag_size: float = 15.0                    # Maximum ammo reserve (if used)
@export var reload_time: float = 2.0   
@export var buffer: float = 0.7                   # Time (in seconds) to reload
var trails = preload("res://player/scene/bullet_trails.tscn")
var trace
var particles = preload("res://player/scene/particles_emit_manager.tscn")
var par
var can_shoot: bool = true
var health: = 200
# ==============================================================================
#                          PLAYER STATE & INPUT
# ==============================================================================

# --- Player State Booleans ---
@export_group("Player_states")
var WALKING: bool = false
var CROUCHING: bool = false
var SPRINTING: bool = false
var IDLE: bool = true
var SHOOTING: bool = false
var SLIDING: bool = false
@export var player_state: String = "IDLE"  # Debug state string
var reloading: bool = false

# --- Direction & Input ---
var direction: Vector3 = Vector3.ZERO    # 3D movement direction vector
var input_dir: Vector2                   # 2D input vector from player

# --- Last Velocity Storage ---
var LAST_VELOCITY: Vector3 = Vector3.ZERO  # Used to check landing impacts

# --- Head Bobbing Variables ---
var head_bob_vector: Vector2 = Vector2.ZERO   # Computed bobbing offset
var head_bobing_index: float = 0.0             # Sine wave index for bobbing
var head_bobing_current_intensity: float = 0.0   # Bobbing intensity based on state

# ==============================================================================
#                                FUNCTIONS
# ==============================================================================

# --- _ready: Initialization ---
func _ready():
	# Update ammo UI
	bullets_labels.text = "AMMO:" + str(max_bullets_per_reload_capacity)
	randomize()
	# Set random spread for each RayCast3D in the container.
	for r in bullets_container.get_children():
		r.target_position.x = randf_range(-spread, spread)
		r.target_position.y = randf_range(-spread, spread)
	# Capture the mouse for FPS control.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Initialize movement speed and debug display.
	SPEED = walking_speed
	speed_label.text = "SPEED: " + str(PLAYER_SPEED)
	# Set collision shapes for standing.
	crouched_collision_shape.disabled = true
	un_crouched_collision_shape.disabled = false
	# Prevent self-collision in obstacle checking.
	obstacle_checker.add_exception(self)
	# Set viewport size.
	sub_viewport.size = DisplayServer.window_get_size()
	var main_envi = camera.environment
	pov_2.environment = main_envi


# --- _unhandled_input: Mouse Look ---
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Vertical rotation: adjust head pitch and clamp between -89° and 89°.
		head.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		# Horizontal rotation: rotate the player body.
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		pov_2._sway(Vector2(-event.relative.x, event.relative.y))
	var main_envi = camera.environment
	pov_2.environment = main_envi

func _process(delta):
	pov_2.set_global_transform(camera.get_global_transform())
	

# --- _physics_process: Main Loop ---
func _physics_process(delta):
	player_current_pos = position.z
	# Update POV to match camera's transform.
	_interaction_manager()
	
	# Update debug speed.
	PLAYER_SPEED = self.velocity.length()
	speed_label.text = "SPEED: " + str(PLAYER_SPEED)
	# update health ui
	health_label.text = str(health)
	# ------ Gravity and Landing ------
	if not is_on_floor():
		velocity.y -= gravity * delta
		player_state = "IN AIR"
	else:
		player_state = "IDLE"
		if LAST_VELOCITY.y < -10.0:
			player_animation.play("roll")
		elif LAST_VELOCITY.y < 0.0:
			player_animation.play("landing")
	
	# ------ Jumping ------
	if Input.is_action_just_pressed("jump") and is_on_floor():
		player_animation.play("jump")
		jump.play()
		velocity.y = JUMP_VELOCITY
		SLIDING = false

	# ------ Movement Input ------
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	if is_on_floor():
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), lerp_speed * delta)
	elif input_dir != Vector2.ZERO:
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), lerp_speed * delta)
	
	# Set WALKING state based on input.
	if direction.length() > 0.1:
		WALKING = true
		IDLE = false
	else:
		WALKING = false
		IDLE = true
	
	# ------ Apply Slide Movement ------
	if SLIDING:
		velocity.x = direction.x * (slide_timer + 0.1) * sliding_speed  
		velocity.z = direction.z * (slide_timer + 0.1) * sliding_speed  
	else:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

	LAST_VELOCITY = velocity
	move_and_slide()
	
	# ------ Handle Shooting & Reloading ------
	_fire_shotgun()
	
	# Separate reload input check to prevent reloading when mag is full.
	if Input.is_action_just_pressed("reload") and max_bullets_per_reload_capacity < bullets_per_reload and not reloading:
		start_reload()
	# Optionally auto-reload if ammo reaches 0.
	if max_bullets_per_reload_capacity <= 0 and not reloading:
		start_reload()
	
	# ------ Other State-Specific Actions ------
	_sprint(delta)
	_crouch(delta)
	_state_manager(delta, PLAYER_SPEED)
	_head_bobing_manager(delta)
	_slide(delta)

	# Update debug state text.
	state.text = "State: " + player_state
	
	# Reset speed and camera FOV when not sprinting, crouching, or sliding.
	if not CROUCHING and not SPRINTING and not SLIDING:
		SPEED = walking_speed
		camera.fov = lerp(camera.fov, camera_fov_default, delta * lerp_speed)
	
	_handle_sideway_animation()

# --- _crouch: Manage Crouching ---
func _crouch(delta):
	# When crouch key is held or sliding is active:
	if Input.is_action_pressed("crouch") or SLIDING:
		SPEED = crouch_walking_speed
		CROUCHING = true
		# Lower camera FOV slightly for crouching.
		camera.fov = lerp(camera.fov, camera_fov_default - 5, delta * lerp_speed)
		# Lower head position.
		head.position.y = lerp(head.position.y, crouching_depth + 0.651, delta * lerp_speed)
		crouched_collision_shape.disabled = false
		un_crouched_collision_shape.disabled = true  # keeping it false while crouching
		# Play crouch sound only once when the key is just pressed.
		if Input.is_action_just_pressed("crouch") and not crouchSoundPlayed:
			$audio/crouch.play()
			crouchSoundPlayed = true
		# Initiate slide if sprinting and moving.
		if SPRINTING and input_dir != Vector2.ZERO:
			SLIDING = true
			slide_dir = input_dir
			slide_timer = slide_timer_max
			# Optionally, you can trigger slide sound here or in _slide.
	else:
		# When not pressing crouch and no obstacle overhead:
		CROUCHING = false
		head.position.y = lerp(head.position.y, 0.651, delta * lerp_speed)
		crouched_collision_shape.disabled = true
		un_crouched_collision_shape.disabled = false
		crouchSoundPlayed = false

# --- _sprint: Manage Sprinting ---
func _sprint(delta):
	# Sprint if moving forward, walking, not crouching, and on the ground.
	if Input.is_action_pressed("sprint") and WALKING and not CROUCHING and is_on_floor() and input_dir.y == -1:
		SPEED = sprinting_speed
		SPRINTING = true
		camera.fov = lerp(camera.fov, sprint_fov + camera_fov_default, delta * lerp_speed)
	else:
		SPRINTING = false

# --- _state_manager: Update State & Head Bobbing Setup ---
func _state_manager(delta, p_speed):
	# Prioritize: Sprint > Sliding > Crouch > Walk > Idle.
	if SPRINTING and p_speed >= 1:
		player_state = "Sprinting"
		head_bobing_index += head_bobing_sprinting_speed * delta
		head_bobing_current_intensity = head_bobing_sprinting_intensity
	elif SLIDING and p_speed >= 1:
		player_state = "Sliding"
		head_bobing_index = 0.0
		head_bobing_current_intensity = 0.0
	elif CROUCHING and p_speed >= 1:
		player_state = "Crouched"
		head_bobing_index += head_bobing_crouching_speed * delta
		head_bobing_current_intensity = head_bobing_crouching_intensity
	elif WALKING and p_speed >= 1:
		player_state = "Walking"
		head_bobing_index += head_bobing_walking_speed * delta
		head_bobing_current_intensity = head_bobing_walking_intensity
	else:
		player_state = "Idle"
		head_bobing_index = 0.0
		head_bobing_current_intensity = 0.0
	
	# Update movement animation manager (if implemented).
	pov_2._movement_animation_manager(SLIDING, WALKING, SPRINTING, SHOOTING, reloading, IDLE)

# --- _head_bobing_manager: Calculate and Apply Head Bobbing ---
func _head_bobing_manager(delta):
	if direction.length() > 0.1 and not SLIDING and is_on_floor():
		# Calculate bobbing offsets.
		head_bob_vector.y = sin(head_bobing_index) * head_bobing_current_intensity
		head_bob_vector.x = sin(head_bobing_index / 2.0) * head_bobing_current_intensity + 0.5
		# Smoothly update eye position.
		eye.position.y = lerp(eye.position.y, head_bob_vector.y / 2.0, delta * lerp_speed)
		eye.position.x = lerp(eye.position.x, head_bob_vector.x, delta * lerp_speed)
	
		var thresh0ld_frequency = -head_bobing_current_intensity + 0.02
		# Play footsteps sound only once when bobbing passes threshold.
		if head_bob_vector.y < thresh0ld_frequency and can_play:
			footsteps.play()
			can_play = false
		elif head_bob_vector.y > thresh0ld_frequency:
			can_play = true

# --- _handle_sideway_animation: Manage Sideways Animation ---
func _handle_sideway_animation():
	if input_dir.x == 1.0:
		player_animation.play("side_way_movement_right", animation_player_speed)
	elif input_dir.x == -1.0:
		player_animation.play("side_way_movement_left", animation_player_speed)

# --- _slide: Manage Sliding Movement ---
func _slide(delta):
	if SLIDING:
		slide_timer -= delta
		camera.rotation.z = lerp(camera.rotation.z, -deg_to_rad(slide_tilt), delta * lerp_speed)
		camera.fov = lerp(camera.fov, 25 + camera_fov_default, delta * lerp_speed)
		# Play slide sound only once when sliding starts.
		if not slideSoundPlayed:
			$audio/sliding.play()
			slideSoundPlayed = true
		if slide_timer <= 0:
			SLIDING = false
			# Reset flags and rotations.
			slideSoundPlayed = false
			camera.rotation.z = lerp(camera.rotation.z, 0.0, delta * lerp_speed)
			pov_2.rotation.z = lerp(pov_2.rotation.z, 0.0, delta * lerp_speed)
			print("slide ended")
			print(slide_dir)
	else:
		slideSoundPlayed = false

# --- _fire_shotgun: Handle Shooting Using RayCast3D ---
func _fire_shotgun():
	# Update ammo UI.
	bullets_labels.text = str(max_bullets_per_reload_capacity)
	
	# Only fire if shoot input is pressed, there is ammo, and not reloading.
	if Input.is_action_just_pressed("shoot") and can_shoot and max_bullets_per_reload_capacity > 0 and not reloading:
		SHOOTING = true
		max_bullets_per_reload_capacity -= 1
		print(pov_2.bar_pos)
		can_shoot = false
		timer.start()
		#par = particles.instantiate()
		# For each RayCast3D bullet, update random spread and check collision.
		for r in bullets_container.get_children():
			r.target_position.x = randf_range(-spread, spread)
			r.target_position.y = randf_range(-spread, spread)
			r.enabled = true
			par = particles.instantiate()
			var trace = trails.instantiate()
			get_tree().current_scene.add_child(trace)
			get_tree().current_scene.add_child(par)
			if r.is_colliding():
				trace.init(barrel_pos.global_transform.origin, r.get_collision_point())
				par._emit_particles( false , r.get_collision_point() , barrel_pos.global_transform.origin)
				if r.is_colliding() and r.get_collider().has_method("_damage"):
					r.get_collider()._damage(damage)
					par._emit_particles( true , r.get_collision_point() , barrel_pos.global_transform.origin)
					player_animation.play("hit_affect")
			else:
				pass
				trace.init(barrel_pos.global_transform.origin, ray_end_pos.global_transform.origin)
		#get_tree().current_scene.add_child(trace)

	else:
		SHOOTING = false


# --- start_reload: Handle Reloading with Delay ---
func start_reload():
	# Do not start reload if magazine is already full.
	if max_bullets_per_reload_capacity >= bullets_per_reload:
		return
	
	reloading = true
	crosshair.hide()
	print("Reloading...")
	await get_tree().create_timer(reload_time).timeout  # Simulate reload delay
	max_bullets_per_reload_capacity = bullets_per_reload  # Refill magazine
	reloading = false
	print("Reloaded! Ammo:", max_bullets_per_reload_capacity)
	crosshair.show()


# makes shooting avalible again after timer runs out
func _on_timer_timeout():
	can_shoot = true



#=======INTRACTION MANAGER
func _interaction_manager():
	if interaction_ray_cast.is_colliding():
		var collider = interaction_ray_cast.get_collider()
		if collider and collider.is_in_group("doors"):
			print(collider)
			print("door")
			# Update the label with the door's locked state.
			interaction_test.text = "Door is " + collider._door_state
			if Input.is_action_just_pressed("interaction"):
				collider.open()
	else:
		interaction_test.text = ""
