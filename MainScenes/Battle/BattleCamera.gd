extends "res://Player/Camera2D.gd"

"""
Battle Camera
	Handles scrolling, zoom and shake of the visible camera during battle
"""

var speed
var target_pos = Vector2()

func _ready():
	timer = $Timer
	._ready()

func start():
	speed = .1
	position.x = 256
	position.y = Game.room_height / 2
	state = "intro_state"
	set_process(true)

func _process(delta):
	._process(delta)
	call(state)

func camera_screenshake(amount, _duration):
	amplitude = amount
	self.duration = _duration
	self.shake = true

func intro_state():
	target_pos.x = Game.room_width *3/4
	target_pos.y = Game.room_height / 2
	
	if position.distance_to(target_pos) < 1:
		position.x = target_pos.x
		position.y = target_pos.y
	
	state = "idle_state"

func idle_state():
	target_pos.x = Game.room_width *3/4
	target_pos.y = Game.room_height / 2
	#camera_approach(target.x,target.y,Game.room_width,Game.room_height,speed/2,speed/2)
	camera_approach(target_pos.x,target_pos.y,1,1,speed/2,speed/2)

func focus_state():
	camera_approach(target_pos.x, Game.room_height/2, .95, .95, speed/2, speed / 1.5)

func _on_Timer_timeout():
	self.shake = false
