extends KinematicBody2D

export (float) var move_speed = 100.0

const LASTE = preload("res://MainScenes/LastEncounter.tscn")

signal encounter

onready var anim = $AnimationPlayer
onready var camera = $Camera2D

var motion = Vector2()
var spritedir = "down"
var state = "move_state"
var last_encounter

func _ready():
	last_encounter = null

func start(pos):
	set_physics_process(true)
	set_process_input(true)
	camera.smoothing_enabled = false
	position = pos
	yield(get_tree().create_timer(0.1),"timeout")
	camera.smoothing_enabled = true
	last_encounter = null

func stop():
	set_physics_process(false)
	set_process_input(false)

func _physics_process(delta):
	z_index = max(0,position.y)
	motion = Vector2()
	#get_input()
	#spritedir_loop()
	call(state)
	if motion != gdata.direction["center"]:
		anim_switch("walk")
	else:
		anim_switch("idle")
	#motion = move_and_slide(motion.normalized() * move_speed)

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
	
	if last_encounter == null:
		last_encounter = LASTE.instance()
		add_child(last_encounter)
		last_encounter.position = position
		last_encounter.distance = rand_range(32, (camera.limit_right - camera.limit_left)/2)
	else:
		if position.distance_to(last_encounter.position) >= last_encounter.distance:
			emit_signal("encounter")

func wait_state():
	stop()