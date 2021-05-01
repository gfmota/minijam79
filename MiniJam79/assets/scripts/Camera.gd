extends Camera2D

var facing : int = 0
onready var prev_camera_x : float = get_camera_position().x
onready var tween : Tween = $Tween

func _process(delta):
	check_facing()
	prev_camera_x = get_camera_position().x

func check_facing():
	var camera_x_delta = get_camera_position().x - prev_camera_x
	var new_facing = sign(camera_x_delta) if (step_decimals(camera_x_delta) < 3) else 0
	if new_facing != 0 && facing != new_facing:
		facing = new_facing
		var camera_offset = get_viewport_rect().size.x * 0.2 * facing
		tween.interpolate_property(self, "position:x", position.x, camera_offset, 0.8, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
