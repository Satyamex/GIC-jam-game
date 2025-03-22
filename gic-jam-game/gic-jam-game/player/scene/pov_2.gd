extends Camera3D
@onready var animation_player = $AnimationPlayer

@onready var fps_pov = $fps_pov
var lerp_speed:float = 4.0
var sens : float = 0.0001
var _sprint_anim_speed: float = 1.5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fps_pov.position.x = lerp(fps_pov.position.x , 0.0 , delta*lerp_speed)
	fps_pov.position.y = lerp(fps_pov.position.y , 0.0 , delta*lerp_speed)
func  _sway(sway_amount):
	fps_pov.position.x  += sway_amount.x *sens
	fps_pov.position.y += sway_amount.y * sens

func _movement_animation_manager(sliding:bool , walking:bool , sprinting:bool , jumping:bool , shooting:bool ,reloading:bool):
	pass
