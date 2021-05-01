extends KinematicBody2D

var motion : Vector2
var initial_height : float
onready var falling : bool = false
onready var sprite : AnimatedSprite = $AnimatedSprite

func _ready():
	initial_height = global_position.y

func _process(delta):
	motion.x = 0
	if falling:
		if is_on_floor():
			sprite.play("hit")
			motion.y = 0
		else:
			motion.y = 760
	else:
		if global_position.y <= initial_height:
			motion.y = 0
		else:
			motion.y = -200
	motion = move_and_slide(motion, Vector2(0, -1))

func _on_WakeUp_body_entered(body):
	if body.is_in_group("hero"):
		sprite.play("idle")

func _on_WakeUp_body_exited(body):
	if body.is_in_group("hero"):
		sprite.play("sleep")

func _on_Fall_body_entered(body):
	if body.is_in_group("hero"):
		falling = true

func _on_Fall_body_exited(body):
	if body.is_in_group("hero"):
		falling = false
