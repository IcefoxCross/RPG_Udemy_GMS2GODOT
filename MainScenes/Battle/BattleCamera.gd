extends "res://Player/Camera2D.gd"

var speed
var state
var target = {}

func _ready():
	timer = $Timer
	._ready()
	set_process(true)

func start():
	speed = .1
	position.x = 256
	position.y = Game.room_height / 2
	state = "intro_state"

func _process(delta):
	._process(delta)
	call(state)

func camera_approach(x,y,width,height,speed,zoom_speed):
	position.x = lerp(position.x, x,speed)
	position.y = lerp(position.y, y,speed)
	zoom = lerp(zoom,Vector2(width/Game.room_width,height/Game.room_height),zoom_speed)

func camera_screenshake(amount, _duration):
	amplitude = amount
	duration = _duration

func intro_state():
	target["x"] = Game.room_width *3/4
	target["y"] = Game.room_height / 2
	
	if position.distance_to(Vector2(target["x"],target["y"])) < 1:
		position.x = target["x"]
		position.y = target["y"]
	
	state = "idle_state"

func idle_state():
	target["x"] = Game.room_width *3/4
	target["y"] = Game.room_height / 2
	camera_approach(target["x"],target["y"],Game.room_width,Game.room_height,speed/2,speed)

func focus_state():
	camera_approach(target["x"], Game.room_height/2, 288, 162, speed/2, speed/2)
