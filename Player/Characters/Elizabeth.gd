extends "res://NPCS/Character.gd"

const LASTE = preload("res://MainScenes/Battle/LastEncounter.tscn")

signal encounter
signal menu_call

onready var camera = $Camera2D
onready var ray = $RayCast2D

var motion = Vector2()
var state = "move_state"
var last_encounter

func _ready():
	portrait = load("res://UI/Assets/Dialog/s_elizabeth_portrait_0.png")
	last_encounter = null
	set_physics_process(false)
	set_process_input(false)

func start(pos, dir = "down"):
	if last_encounter != null:
		last_encounter.queue_free()
		last_encounter = null
	set_physics_process(true)
	set_process_input(true)
	camera.smoothing_enabled = false
	position = pos
	spritedir = dir
	match dir:
		"left":
			ray.cast_to = Vector2(-16,0)
		"right":
			ray.cast_to = Vector2(16,0)
		"up":
			ray.cast_to = Vector2(0,-16)
		"down":
			ray.cast_to = Vector2(0,16)
	yield(get_tree().create_timer(0.1),"timeout")
	camera.smoothing_enabled = true

func stop():
	set_physics_process(false)
	set_process_input(false)

func resume():
	set_physics_process(true)
	set_process_input(true)

func _physics_process(delta):
	._physics_process(delta)
	motion = Vector2()
	call(state)
	if motion != GData.direction["center"]:
		anim_switch("walk")
	else:
		anim_switch("idle")

func _unhandled_input(event):
	if event.is_action_pressed("action"):
		var obj = interactable()
		if obj != null:
			obj.interact(self)
		else:
			print("none")
	if event.is_action_pressed("ui_cancel"):
		if state == "move_state":
			emit_signal("menu_call")


### STATES ###
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
	
func resume_state():
	set_physics_process(false)
	set_process_input(false)
	state = "move_state"

func talking_state():
	anim_switch("idle")
	if not get_tree().has_group("dialog") and not get_tree().has_group("message"):
		state = "move_state"

func cutscene_state():
	motion = spritedir_set()

### FUNCS ###
func get_input():
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

func spritedir_loop():
	match motion:
		Vector2(-1,0):
			spritedir = "left"
			ray.cast_to = Vector2(-16,0)
		Vector2(1,0):
			spritedir = "right"
			ray.cast_to = Vector2(16,0)
		Vector2(0,-1):
			spritedir = "up"
			ray.cast_to = Vector2(0,-16)
		Vector2(0,1):
			spritedir = "down"
			ray.cast_to = Vector2(0,16)

func anim_switch(animation):
	var new_anim = str(animation,spritedir)
	if anim.has_animation(new_anim):
		if anim.current_animation != new_anim:
			anim.play(new_anim)

func interactable():
	var obj = ray.get_collider()
	if obj != null and obj.get_parent().is_in_group("interact"):
		return obj.get_parent()
	else:
		return null