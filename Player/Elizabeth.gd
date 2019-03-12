extends KinematicBody2D

export (float) var move_speed = 100.0

onready var anim = $AnimationPlayer
onready var camera = $Camera2D

var motion = Vector2()
var spritedir = "down"
var state = "move_state"

func _ready():
	pass

func start(pos):
	set_physics_process(true)
	set_process_input(true)
	camera.smoothing_enabled = false
	position = pos
	yield(get_tree().create_timer(0.1),"timeout")
	camera.smoothing_enabled = true

func stop():
	set_physics_process(false)
	set_process_input(false)

func _physics_process(delta):
	motion = Vector2()
	#get_input()
	#spritedir_loop()
	call(state)
	if motion != gdata.direction["center"]:
		anim_switch("walk")
	else:
		anim_switch("idle")
	#motion = move_and_slide(motion.normalized() * move_speed)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		camera.shake = true

func get_input():
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

func spritedir_loop():
	match motion:
		Vector2(-1,0):
			spritedir = "left"
		Vector2(1,0):
			spritedir = "right"
		Vector2(0,-1):
			spritedir = "up"
		Vector2(0,1):
			spritedir = "down"

func anim_switch(animation):
	var new_anim = str(animation,spritedir)
	if anim.current_animation != new_anim:
		anim.play(new_anim)

func move_state():
	get_input()
	spritedir_loop()
	motion = move_and_slide(motion.normalized() * move_speed)