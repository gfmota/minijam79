extends KinematicBody2D

const ACCELERATION = 40
const GRAVITY = 20
const JUMP_HEIGHT = -500
const MAX_SPEED = 320

var extra_jump : bool
var air_dash : bool
var motion : Vector2
onready var sprite : AnimatedSprite = $AnimatedSprite
onready var dash_timer : Timer = $DashTimer
onready var dash_cooldown : Timer = $DashCooldown

func _physics_process(delta):
	motion.y += GRAVITY
	var friction = false
	
	if dash_timer.is_stopped():
		if Input.is_action_pressed("right"):
			motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
			sprite.flip_h = false
		elif Input.is_action_pressed("left"):
			motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
			sprite.flip_h = true
		else:
			friction = true
	
		if is_on_floor():
			air_dash = true
			extra_jump = true
			if Input.is_action_just_pressed("jump"):
				motion.y = JUMP_HEIGHT
			if friction:
				motion.x = lerp(motion.x, 0, 0.2)
				sprite.play("idle")
			else:
				sprite.play("run")
		else:
			if friction:
				motion.x = lerp(motion.x, 0, 0.05)
			if extra_jump:
				if motion.y < 0:
					sprite.play("jump")
				else:
					sprite.play("fall")
				if Input.is_action_just_pressed("jump"):
					motion.y = JUMP_HEIGHT
					extra_jump = false
			else:
				sprite.play("double_jump")
	else:
		motion = Vector2((-1 if sprite.flip_h else 1) * MAX_SPEED * 3, 0)
		sprite.play("dash")
	
	motion = move_and_slide(motion, Vector2(0, -1))

func _input(event):
	if event.is_action_pressed("dash") and dash_cooldown.is_stopped() and air_dash:
		dash_timer.start()
		dash_cooldown.start()
		air_dash = false
